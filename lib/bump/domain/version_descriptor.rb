
require 'yaml'

module Bump

    class VersionDescriptor

        def initialize config
            @config = config

            @version = VersionFactory.fromString @config['version']

            @before_version = @version.to_s
            @after_version = @version.to_s

        end

        def resetAfterVersion
            @after_version = @version.to_s
            @config['version'] = @after_version
        end

        def toYaml
            @config.to_yaml
        end

        def majorBump
            @version.bump 'major'

            resetAfterVersion
        end

        def minorBump
            @version.bump 'minor'

            resetAfterVersion
        end

        def patchBump
            @version.bump 'patch'

            resetAfterVersion
        end

        def config
            @config
        end

        def rewriteRules
            return @config['files'].map { |file, param|
                FileRewriteRuleFactory.create(file, param, @before_version, @after_version)
            }.flatten
        end

        def afterVersion
            @after_version
        end

        def beforeVersion
            @before_version
        end

    end

end
