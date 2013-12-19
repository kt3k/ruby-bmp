

module Bump

    class VersionFactory

        VERSION_REGEXP = /^(\d).(\d).(\d)(\S*)$/

        def self.fromString version_string
            match = VERSION_REGEXP.match version_string

            return Version.new match[1].to_i, match[2].to_i, match[3].to_i, match[4]
        end

    end

end
