# lib/bump/logger.rb

module Bump

    class Logger

        no_color = false

        def log message = ''
            puts message
        end

        def log_green message = ''
            log green message
        end

        def log_red message = ''
            log red message
        end

        def error message = ''
            puts message
        end

        def warn message = ''
            puts message
        end

        def info message = ''
            puts message
        end

        def debug message = ''
            puts message
        end

        def verbose message = ''
            puts message
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
