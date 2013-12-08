
require 'bump/version'
require 'yaml'
require 'optparse'
require 'slop'

module Bump

    class Version

        def initialize(major, minor, patch)
            @major = major
            @minor = minor
            @patch = patch
        end

        def bump(level)

            case level
            when 'major'
                @major += 1
                @minor = 0
                @patch = 0
            when 'minor'
                @minor += 1
                @patch = 0
            when 'patch'
                @patch += 1
            end

        end

        def to_s
            @major.to_s + '.' + @minor.to_s + '.' + @patch.to_s
        end

    end

    class VersionFactory

        def self.fromString(str)
            arr = str.split '.'

            return Version.new arr[0].to_i, arr[1].to_i, arr[2].to_i
        end

    end

    class FileRewriteRule

        PLACEHOLDER_PATTERN = '%.%.%'

        def initialize(file, pattern, before_version, after_version)
            @file = file
            @pattern = pattern || PLACEHOLDER_PATTERN # default pattern is '%.%.%'
            @before_version = before_version
            @after_version = after_version
        end

        def prepare
            @before_pattern = @pattern.sub PLACEHOLDER_PATTERN, @before_version
            @after_pattern = @pattern.sub PLACEHOLDER_PATTERN, @after_version
        end

        def file
            @file
        end

        def beforePattern
            @before_pattern
        end

        def afterPattern
            @after_pattern
        end

        def perform
            prepare

            contents = File.read @file, :encoding => Encoding::UTF_8

            if contents.index @before_pattern
                File.write @file, contents.sub(@before_pattern, @after_pattern)

                return true
            else
                return false
            end
        end

    end

    class FileRewriteRuleFactory

        def self.create(file, param, before_version, after_version)

            case param
            when String
                return FileRewriteRule.new file, param, before_version, after_version
            when Array
                return param.map { |param| FileRewriteRule.new file, param, before_version, after_version }.flatten
            else
                return FileRewriteRule.new file, nil, before_version, after_version
            end

        end
    end

    class VersionDescriptorRepository

        def initialize file
            @file = file
        end

        def fromFile
            VersionDescriptor.new YAML.load_file @file
        end

        def save descriptor
            File.write @file, descriptor.toYaml
        end

    end

    class VersionDescriptor

        def initialize config
            @config = config

            @version = VersionFactory.fromString @config['version']

            @before_version = @version.to_s
            @after_version = @version.to_s

        end

        def resetAfterVersion
            @after_version = @version.to_s
            @config['version'] = @after_version
        end

        def toYaml
            @config.to_yaml
        end

        def majorBump
            @version.bump 'major'

            resetAfterVersion
        end

        def minorBump
            @version.bump 'minor'

            resetAfterVersion
        end

        def patchBump
            @version.bump 'patch'

            resetAfterVersion
        end

        def config
            @config
        end

        def rewriteRules
            return @config['files'].map { |file, param|
                FileRewriteRuleFactory.create(file, param, @before_version, @after_version)
            }.flatten
        end

        def afterVersion
            @after_version
        end

        def beforeVersion
            @before_version
        end

    end

    class Application

        def initialize options, help, version, file, logger
            @options = options
            @help = help
            @version = version
            @file = file
            @logger = logger
        end

        def selectAction
            if @options[:help]
                return :help
            end

            if @options[:version]
                return :version
            end

            if !@options[:major] && !@options[:minor] && !@options[:patch] && !@options[:fix]
                return :help
            end

            return :bump
        end

        def actionVersion
            @logger.log "bump v#{@version}"
        end

        def actionHelp
            @logger.log @help
        end

        def actionBump

            repo = VersionDescriptorRepository.new @file

            srv = repo.fromFile

            if @options[:patch]
                srv.patchBump

                @logger.log 'Bump patch level'
                @logger.log "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if @options[:minor]
                srv.minorBump

                @logger.log 'Bump minor level'
                @logger.log "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if @options[:major]
                srv.majorBump

                @logger.log 'Bump major level'
                @logger.log "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            @logger.log

            srv.rewriteRules.each do |rule|
                result = rule.perform

                if result
                    @logger.log "#{rule.file}"
                    @logger.log "  Performed pattern replacement:"
                    @logger.log "  '#{rule.beforePattern}' => '#{rule.afterPattern}'"
                    @logger.log
                else
                    @logger.log "  Current version pattern ('#{rule.beforePattern}') not found!"
                    @logger.log
                end
            end

            repo.save srv

            if @options[:fix]
                @logger.log `git add . ; git commit -m "Bump to version v#{after_version}"`
            end
        end

        def actionError
            @logger.error @error_message
        end

        def main

            action = selectAction

            case action
            when :version
                actionVersion
            when :help
                actionHelp
            when :bump
                actionBump
            when :error
                actionError
            end

        end

    end

    class Logger

        def log message = ''
            puts message
        end

        def error message = ''
            puts message
        end

        def warn message = ''
            puts message
        end

        def info message = ''
            puts message
        end

        def debug message = ''
            puts message
        end

        def verbose message = ''
            puts message
        end

    end

    class CLI

        VERSION_FILE = '.version'

        def main

            opts = Slop.parse do
                banner 'Usage: bump [-p|-m|-j] [-f]'

                on :p, :patch, 'bump patch (0.0.1) level'
                on :m, :minor, 'bump minor (0.1.0) level'
                on :j, :major, 'bump major (1.0.0) level'
                on :f, :fix, 'fix bumping and commit current changes (git required)'
                on :h, :help, 'show this help and exit'
                on :v, :version, 'show version and exit'
            end

            app = Application.new opts.to_hash, opts.to_s, Bump::VERSION, VERSION_FILE, Logger.new

            app.main

        end

    end

end
