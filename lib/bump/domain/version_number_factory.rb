module Bump
    # The factory class for the version number
    class VersionNumberFactory
        # Regexp for version expression
        VERSION_REGEXP = /^(\d+).(\d+).(\d+)(-(\S*))?$/

        # Creates the version number object from the string
        #
        # @param [String] version_string
        # @return [Bump::VersionNumber]
        def self.from_string(version_string)
            match = VERSION_REGEXP.match version_string

            VersionNumber.new match[1].to_i, match[2].to_i, match[3].to_i, match[5]
        end
    end
end
