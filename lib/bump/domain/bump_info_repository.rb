require 'yaml'

module Bump

    # The repository class for the bump info
    # persistence in file as yaml string
    class BumpInfoRepository

        # @param [String] file
        def initialize(file)
            @file = file
        end

        # Gets the bump info from the given file
        #
        # @param [String] file
        # @return [Bump::BumpInfo]
        def fromFile
            config = YAML.load_file @file
            version = VersionNumberFactory.fromString config['version']

            BumpInfo.new version, config['files'], config['commit']
        end

        # Saves the bump info
        #
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def save(bump_info)
            File.write @file, toYaml(bump_info)
        end

        # @private
        # @param [Bump::BumpInfo] bumpInfo
        # @return [Hash]
        def toYaml(bump_info)
            hash = { 'version' => bump_info.version.to_s }

            hash['commit'] = bump_info.commit if bump_info.commit

            hash['files'] = bump_info.files

            hash.to_yaml
        end

    end

end
