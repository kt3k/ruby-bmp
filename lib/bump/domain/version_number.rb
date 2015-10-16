# lib/bump/domain/version.rb

module Bump

    # The version number model
    class VersionNumber

        # @param [Integer] major
        # @param [Integer] minor
        # @param [Integer] patch
        # @param [String, nil] preid
        def initialize major, minor, patch, preid = nil
            @major = major
            @minor = minor
            @patch = patch
            @preid = preid
        end

        # @param [Symbol] level
        def bump level

            case level
            when :major
                @major += 1
                @minor = 0
                @patch = 0
            when :minor
                @minor += 1
                @patch = 0
            when :patch
                @patch += 1
            end
            @preid = nil

        end

        def patchBump
            bump :patch
        end

        def minorBump
            bump :minor
        end

        def majorBump
            bump :major
        end

        def setPreid preid
            @preid = preid
        end

        # Returns the string representation of the version
        #
        # @return [String]
        def to_s
            label = @major.to_s + '.' + @minor.to_s + '.' + @patch.to_s

            if @preid
                label = label + '-' + @preid
            end

            label

        end

    end

end
