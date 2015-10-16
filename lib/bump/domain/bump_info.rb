
require 'yaml'

module Bump

    class BumpInfo

        def initialize config
            @config = config

            @version = VersionNumberFactory.fromString @config['version']

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

        def updateRules
            createUpdateRules
        end

        # Creates file update rules according to the current settings.
        #
        # @return [Bump::FileRewriteRule[]]
        def createUpdateRules
            @config['files'].map { |file, pattern|
                FileUpdateRuleFactory.create(file, pattern, @before_version, @after_version)
            }.flatten
        end

        # Performs all updates.
        def performUpdate

            createUpdateRules.each do |rule|

                rule.perform

            end

        end

        # Checks the all the version patterns are available
        #
        # @return [Boolean]
        def check

            createUpdateRules.each do |rule|

                if not rule.patternExists
                    return false
                end

            end

            return true

        end

        # Returns the version number after the bumping.
        #
        # @return [String]
        def afterVersion
            @after_version
        end

        # Returns the version number before the bumping.
        #
        # @return [String]
        def beforeVersion
            @before_version
        end

    end

end
