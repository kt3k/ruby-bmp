
require 'yaml'

module Bump

    # The bump information model
    class BumpInfo

        # @param [Bump::VersionNumber] version
        # @param [Array] files
        def initialize version, files
            @version = version
            @files = files

            @before_version = @version.to_s
            @after_version = @version.to_s

        end

        # Returns the version number object
        #
        # @return [Bump::VersionNumber]
        def version
            @version
        end

        # Returns files setting list
        #
        # @return [Array]
        def files
            @files
        end

        # Performs bumping version
        #
        # @param [Symbol] level
        # @return [void]
        def bump level
            @version.bump level
            @after_version = @version.to_s
        end

        # Gets the file update rules
        #
        # @return [Array<Bump::FileUpdateRules>]
        def updateRules
            createUpdateRules
        end

        # Creates file update rules according to the current settings.
        #
        # @return [Array<Bump::FileUpdateRule>]
        def createUpdateRules
            @files.map { |file, pattern|
                FileUpdateRuleFactory.create(file, pattern, @before_version, @after_version)
            }.flatten
        end

        # Performs all updates.
        #
        # @return [void]
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
