

module Bump

    # The factory class for the version number
    class VersionNumberFactory

        VERSION_REGEXP = /^(\d+).(\d+).(\d+)(-(\S*))?$/

        def self.fromString version_string
            match = VERSION_REGEXP.match version_string

            return VersionNumber.new match[1].to_i, match[2].to_i, match[3].to_i, match[5]
        end

    end

end
