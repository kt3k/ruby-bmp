# lib/bump/domain/version.rb

module Bump

    class VersionNumber

        def initialize major, minor, patch, suffix = ''
            @major = major
            @minor = minor
            @patch = patch
            @suffix = suffix
        end

        def bump level

            case level
            when 'major'
                @major += 1
                @minor = 0
                @patch = 0
                @suffix = ''
            when 'minor'
                @minor += 1
                @patch = 0
                @suffix = ''
            when 'patch'
                @patch += 1
                @suffix = ''
            end

        end

        def patchBump
            bump 'patch'
        end

        def minorBump
            bump 'minor'
        end

        def majorBump
            bump 'major'
        end

        def append suffix
            @suffix = suffix
        end

        def to_s
            @major.to_s + '.' + @minor.to_s + '.' + @patch.to_s + @suffix
        end

    end

end
