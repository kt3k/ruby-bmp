

module Bump

    class FileRewriteRule

        PLACEHOLDER_PATTERN = '%.%.%'

        # @param [String] file
        # @param [String] pattern
        # @param [Bump::Version] before_version
        # @param [Bump::Version] after_version
        def initialize(file, pattern, before_version, after_version)
            @file = file
            @pattern = pattern || PLACEHOLDER_PATTERN # default pattern is '%.%.%'
            @before_version = before_version
            @after_version = after_version
            @before_pattern = @pattern.sub PLACEHOLDER_PATTERN, @before_version
            @after_pattern = @pattern.sub PLACEHOLDER_PATTERN, @after_version
        end

        def file
            @file
        end

        def beforePattern
            @before_pattern
        end

        def afterPattern
            @after_pattern
        end

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
        # @return [Boolean]
        def perform
            contents = fileGetContents

            if contents.index @before_pattern

                File.write @file, contents.sub(@before_pattern, @after_pattern)

                return true

            else

                return false

            end
        end

    end

end
