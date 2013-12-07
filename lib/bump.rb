
require 'bump/version'
require 'yaml'
require 'optparse'

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

            prepare
        end

        def prepare
            @before_pattern = @pattern.sub PLACEHOLDER_PATTERN, @before_version
            @after_pattern = @pattern.sub PLACEHOLDER_PATTERN, @after_version
        end

        def perform
            contents = File.read @file, :encoding => Encoding::UTF_8
            File.write @file, contents.sub(@before_pattern, @after_pattern)
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

    class CLI

        VERSION_FILE = '.version'

        def main

            config = YAML.load_file VERSION_FILE

            puts config

            version = Version.createFromString config['version']

            p before_version = version.to_s()

            opt = OptionParser.new

            commit_file = false

            opt.on('-l') { |x| version.bump 'major' }
            opt.on('-m') { |x| version.bump 'minor' }
            opt.on('-s') { |x| version.bump 'patch' }
            opt.on('-f') { |x| commit_file = true }

            opt.parse!(ARGV)

            p after_version = version.to_s()

            p config['files'].map { |file, param|
                FileRewriteRuleFactory.create(file, param, before_version, after_version)

            }.flatten.each { |rewriteRule|
                rewriteRule.perform

            }

            config['version'] = after_version

            puts config

            File.write VERSION_FILE, config.to_yaml

            if commit_file
                puts `git add . ; git commit -m "Bump to version v#{after_version}"`
            end

        end

    end

end
