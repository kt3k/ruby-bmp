require 'yaml'

module Bump

    # The bump information model
    class BumpInfo

        attr_reader :version, :files, :commit, :after_version, :before_version

        # @param [Bump::VersionNumber] version The version
        # @param [Array] files The replace patterns
        # @param [String] commit The commit message
        def initialize(version, files, commit)
            @version = version
            @files = files
            @commit = commit

            @commit = 'Bump to version v%.%.%' unless @commit

            @before_version = @version.to_s
            @after_version = @version.to_s
        end

        # Gets the commit message with the current version number
        #
        # @return [String]
        def getCommitMessage
            @commit.sub '%.%.%', @after_version
        end

        # Performs bumping version
        #
        # @param [Symbol] level
        # @return [void]
        def bump(level)
            @version.bump level
            @after_version = @version.to_s
        end

        # Sets the preid
        #
        # @return [void]
        def setPreid(preid)
            @version.setPreid preid
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
        # @private
        # @return [Array<Bump::FileUpdateRule>]
        def createUpdateRules
            @files.map do |file, pattern|

                FileUpdateRuleFactory.create(file, pattern, @before_version, @after_version)

            end.flatten
        end

        # Performs all updates.
        #
        # @return [void]
        def performUpdate
            createUpdateRules.each(&:perform)
        end

        # Checks the all the version patterns are available
        #
        # @return [Boolean]
        def check
            createUpdateRules.each do |rule|

                return false if !rule.fileExists || !rule.patternExists

            end

            true
        end

    end

end
