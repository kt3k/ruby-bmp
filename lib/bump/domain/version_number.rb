module Bump
    # The version number model
    class VersionNumber
        # @param [Integer] major
        # @param [Integer] minor
        # @param [Integer] patch
        # @param [String, nil] preid
        def initialize(major, minor, patch, preid = nil)
            @major = major
            @minor = minor
            @patch = patch
            @preid = preid
        end

        # Bumps the version at the given level
        #
        # @param [Symbol] level
        # @return [void]
        def bump(level)
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

        # Sets the preid
        #
        # @return [void]
        def setPreid(preid)
            @preid = preid
        end

        # Returns the string representation of the version
        #
        # @return [String]
        def to_s
            label = @major.to_s + '.' + @minor.to_s + '.' + @patch.to_s

            label = label + '-' + @preid if @preid

            label
        end
    end
end
