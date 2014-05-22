# lib/bump/logger.rb

module Bump

    class Logger

        no_color = false

        def log message = '', breakline = true
            print message

            if breakline
                print "\n"
            end
        end

        def log_green message = '', breakline = true
            log green(message), breakline
        end

        def log_red message = '', breakline = true
            log red(message), breakline
        end

        def error message = '', breakline = true
            puts message, breakline
        end

        def warn message = '', breakline = true
            puts message, breakline
        end

        def info message = '', breakline = true
            puts message, breakline
        end

        def debug message = '', breakline = true
            puts message, breakline
        end

        def verbose message = '', breakline = true
            puts message, breakline
        end

        def colorize text, color_code
            if @no_color
                text
            else
                "\e[#{color_code}m#{text}\e[0m"
            end
        end

        def green text
            colorize text, 32
        end

        def red text
            colorize text, 31
        end

    end

end
