module Bump
    # The file update rule model
    #
    # is able to perform actual file update
    class FileUpdateRule
        attr_reader :file, :before_pattern, :after_pattern

        # The placeholder pattern
        PLACEHOLDER_PATTERN = '%.%.%'.freeze

        # @param [String] file
        # @param [String] pattern
        # @param [Bump::VersionNumber] before_version
        # @param [Bump::VersionNumber] after_version
        def initialize(file, pattern, before_version, after_version)
            @file = file
            @pattern = pattern || PLACEHOLDER_PATTERN # default pattern is '%.%.%'
            @before_version = before_version
            @after_version = after_version
            @before_pattern = @pattern.sub PLACEHOLDER_PATTERN, @before_version
            @after_pattern = @pattern.sub PLACEHOLDER_PATTERN, @after_version
        end

        # Gets the contents of the file
        #
        # @return [String]
        def file_get_contents
            File.read @file, encoding: Encoding::UTF_8
        end

        # Returns true if the file exists
        # @return [Boolean]
        def file_exists
            File.exist? @file
        end

        # Checks if the pattern found in the file
        # @return [Boolean]
        def pattern_exists
            !file_get_contents.index(@before_pattern).nil?
        end

        # Performs file update
        # @return [void]
        def perform
            File.write @file, file_get_contents.sub(@before_pattern, @after_pattern)
        end
    end
end
