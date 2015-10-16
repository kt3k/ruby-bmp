

require 'yaml'

module Bump

    class BumpInfoRepository

        def initialize file
            @file = file
        end

        # Gets the bump info from the given file
        #
        # @param [String] file
        def fromFile
            BumpInfo.new YAML.load_file @file
        end

        # Saves the bump info
        #
        # @param [Bump::BumpInfo] bumpInfo
        def save bumpInfo
            File.write @file, bumpInfo.toYaml
        end

    end

end
