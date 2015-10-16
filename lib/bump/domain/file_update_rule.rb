

module Bump

    # The file update rule model
    #
    # is able to perform actual file update
    class FileUpdateRule

        # The placeholder pattern
        PLACEHOLDER_PATTERN = '%.%.%'

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

        # Gets the file name
        #
        # @return [String]
        def file
            @file
        end

        # Gets the version string before bumping
        #
        # @return [String]
        def beforePattern
            @before_pattern
        end

        # Gets the version string after bumping
        #
        # @return [String]
        def afterPattern
            @after_pattern
        end

        # Gets the contents of the file
        #
        # @return [String]
        def fileGetContents
            File.read @file, :encoding => Encoding::UTF_8
        end

        # Checks if the pattern found in the file
        #
        # @return [Boolean]
        def patternExists
            fileGetContents.index @before_pattern
        end

        # Performs file update
        #
        # @return [void]
        def perform
            File.write @file, fileGetContents.sub(@before_pattern, @after_pattern)
        end

    end

end
