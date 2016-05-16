# lib/bump/logger.rb

module Bump

    # The logging class
    class Logger

        def initialize(no_color = nil)
            @no_color = no_color
        end

        # Logs the message.
        #
        # @param [String] message
        # @param [Boolean] breakline
        # @return [void]
        def log(message = '', breakline = true)
            print message

            print "\n" if breakline
        end

        # Colorize the text by the color code.
        #
        # @param [String] text
        # @param [Integer] color_code
        # @return [String]
        def colorize(text, color_code)
            if @no_color
                text
            else
                "\e[#{color_code}m#{text}\e[0m"
            end
        end

        # Returns a green string.
        #
        # @param [String] text
        # @return [String]
        def green(text)
            colorize text, 32
        end

        # Returns a red string.
        #
        # @param [String] text
        # @return [String]
        def red(text)
            colorize text, 31
        end

    end

end
