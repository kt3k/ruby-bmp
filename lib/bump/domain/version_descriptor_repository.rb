

require 'yaml'

module Bump

    class VersionDescriptorRepository

        def initialize file
            @file = file
        end

        def fromFile
            VersionDescriptor.new YAML.load_file @file
        end

        def save descriptor
            File.write @file, descriptor.toYaml
        end

    end

end
