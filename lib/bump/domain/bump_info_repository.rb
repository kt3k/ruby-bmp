

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

            config = YAML.load_file @file
            version = VersionNumberFactory.fromString config['version']
            files = config['files']

            BumpInfo.new version, files

        end

        # Saves the bump info
        #
        # @param [Bump::BumpInfo] bumpInfo
        def save bumpInfo
            File.write @file, bumpInfo.toYaml
        end

    end

end
