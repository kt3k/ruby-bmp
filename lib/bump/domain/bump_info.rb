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
    # @return [String]
    def commit_message
      @commit.sub '%.%.%', @after_version
    end

    # Performs bumping version.
    # @param [Symbol] level
    def bump(level)
      @version.bump level
      @after_version = @version.to_s
    end

    # Sets the preid.
    # @param [String] preid The pre id
    def preid=(preid)
      @version.preid = preid
      @after_version = @version.to_s
    end

    # Gets the file update rules.
    # @return [Array<Bump::FileUpdateRules>]
    def update_rules
      create_update_rules
    end

    # Creates file update rules according to the current settings.
    # @private
    # @return [Array<Bump::FileUpdateRule>]
    def create_update_rules
      @files.map do |file, pattern|
        FileUpdateRuleFactory.create(file, pattern, @before_version, @after_version)
      end.flatten
    end

    # Performs all updates.
    #
    # @return [void]
    def perform_update
      create_update_rules.each(&:perform)
    end

    # Checks the all the version patterns are available
    # @return [Boolean]
    def valid?
      create_update_rules.each do |rule|
        return false if !rule.file_exists || !rule.pattern_exists
      end

      true
    end
  end
end
