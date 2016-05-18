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
        def from_file
            config = YAML.load_file @file
            version = VersionNumberFactory.from_string config['version']

            BumpInfo.new version, config['files'], config['commit']
        end

        # Saves the bump info
        #
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def save(bump_info)
            File.write @file, to_yaml(bump_info)
        end

        # @private
        # @param [Bump::BumpInfo] bumpInfo
        # @return [Hash]
        def to_yaml(bump_info)
            hash = { 'version' => bump_info.version.to_s }

            hash['commit'] = bump_info.commit if bump_info.commit

            hash['files'] = bump_info.files

            hash.to_yaml
        end
    end
end
