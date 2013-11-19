#! /usr/bin/env ruby

require 'yaml'
require 'optparse'

VERSION_FILE = '.version'

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

class VersionConversion

    def initialize(file, param, before_version, after_version)
        @file = file
        @param = param
        @before_version = before_version
        @after_version = after_version
    end

    def prepare
        case @param
        when String
            @pattern = @param
        else
            @pattern = '#{V}'
        end

        return self
    end

    def convert
        before_pattern = @pattern.sub '#{V}', @before_version
        after_pattern = @pattern.sub '#{V}', @after_version

        contents = File.read @file, :encoding => Encoding::UTF_8
        File.write @file, contents.sub(before_pattern, after_pattern)
    end

end

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

config['files'].each { |file, param|
    conversion = VersionConversion.new(file, param, before_version, after_version).prepare.convert
}

config['version'] = after_version

puts config

File.write VERSION_FILE, config.to_yaml

if commit_file
    puts `git add . ; git commit -m "Bump to version v#{after_version}"`
end
