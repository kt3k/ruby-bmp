
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

        def self.createFromString(str)

            arr = str.split '.'

            self.new arr[0].to_i, arr[1].to_i, arr[2].to_i

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

    class VersionBumpService

        def initialize(config, file)
            @config = config
            @file = file

            @version = Version.createFromString @config['version']

            @before_version = @version.to_s
            @after_version = @version.to_s


        end

        def resetAfterVersion
            @after_version = @version.to_s
            @config['version'] = @after_version
        end

        def self.createFromFile file
            config = YAML.load_file file
            self.new config, file
        end

        def saveConfig
            File.write @file, config.to_yaml
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
            return config['files'].map { |file, param|
                FileRewriteRuleFactory.create(file, param, @before_version, @after_version)
            }.flatten
        end

        def performFileRewrite

            rewriteRules.each do |rewrite_rule|
                rewrite_rule.perform
            end
        end

        def afterVersion
            @after_version
        end

        def beforeVersion
            @before_version
        end

    end

    class CLI

        VERSION_FILE = '.version'

        def main

            srv = VersionBumpService.createFromFile VERSION_FILE

            p srv.config

            opts = Slop.parse do
                banner 'Usage: bump [-p|--patch] [-m|--minor] [-j|--major] [-f|--fix]'

                on :p, :patch, 'bump patch (0.0.1) level'
                on :m, :minor, 'bump minor (0.1.0) level'
                on :j, :major, 'bump major (1.0.0) level'
                on :f, :fix, 'fix bumping and commit current changes (git required)'
                on :h, :help, 'show this help and exit'
                on :v, :version, 'show version and exit' do
                    puts "bump v#{Bump::VERSION}"

                    exit
                end
            end

            puts opts.to_hash

            if opts.help?
                puts opts

                exit
            end

            if opts.patch?
                srv.patchBump

                puts 'Bump patch level'
                puts "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if opts.minor?
                srv.minorBump

                puts 'Bump minor level'
                puts "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if opts.major?
                srv.majorBump

                puts 'Bump major level'
                puts "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            puts

            srv.rewriteRules.each do |rule|
                result = rule.perform

                if result
                    puts "#{rule.file}"
                    puts "  Performed pattern replacement:"
                    puts "  '#{rule.beforePattern}' => '#{rule.afterPattern}'"
                    puts
                else
                    puts "  Current version pattern ('#{rule.beforePattern}') not found!"
                    puts
                end
            end

            srv.saveConfig

            if opts.fix?
                puts `git add . ; git commit -m "Bump to version v#{after_version}"`
            end

        end

    end

end
