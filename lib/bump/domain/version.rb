# lib/bump/domain/version.rb

module Bump

    class Version

        def initialize major, minor, patch
            @major = major
            @minor = minor
            @patch = patch
        end

        def bump level

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

end
