

require 'yaml'

module Bump

    # The repository class for the bump info
    # persistence in file as yaml string
    class BumpInfoRepository

        # @param [String] file
        def initialize file
            @file = file
        end

        # Gets the bump info from the given file
        #
        # @param [String] file
        # @return [Bump::BumpInfo]
        def fromFile

            config = YAML.load_file @file
            version = VersionNumberFactory.fromString config['version']
            files = config['files']

            BumpInfo.new version, files

        end

        # Saves the bump info
        #
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def save bumpInfo
            File.write @file, toYaml(bumpInfo)
        end

        # @private
        # @param [Bump::BumpInfo] bumpInfo
        # @return [Hash]
        def toYaml bumpInfo

            {"version" => bumpInfo.version.to_s, "files" => bumpInfo.files}.to_yaml

        end

    end

end
