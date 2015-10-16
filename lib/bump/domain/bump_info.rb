
require 'yaml'

module Bump

    class BumpInfo

        # @param [Bump::VersionNumber] version
        # @param [Array] files
        def initialize version, files
            @version = version
            @files = files

            @before_version = @version.to_s
            @after_version = @version.to_s

        end

        def version
            @version
        end

        def files
            @files
        end

        def majorBump
            @version.bump 'major'
            @after_version = @version.to_s
        end

        def minorBump
            @version.bump 'minor'
            @after_version = @version.to_s
        end

        def patchBump
            @version.bump 'patch'
            @after_version = @version.to_s
        end

        def updateRules
            createUpdateRules
        end

        # Creates file update rules according to the current settings.
        #
        # @return [Bump::FileUpdateRule[]]
        def createUpdateRules
            @files.map { |file, pattern|
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
