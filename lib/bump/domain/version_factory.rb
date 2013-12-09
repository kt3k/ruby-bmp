

module Bump

    class VersionFactory

        def self.fromString str
            arr = str.split '.'

            return Version.new arr[0].to_i, arr[1].to_i, arr[2].to_i
        end

    end

end
