

module Bump

    class FileRewriteRule

        PLACEHOLDER_PATTERN = '%.%.%'

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

        def perform
            contents = File.read @file, :encoding => Encoding::UTF_8

            if contents.index @before_pattern
                File.write @file, contents.sub(@before_pattern, @after_pattern)

                return true
            else
                return false
            end
        end

    end

end
