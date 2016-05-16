

module Bump

    # Command class executes shell command
    class Command

        # @param [Bump::Logger] logger
        def initialize(logger)
            @logger = logger
        end

        # @param [String] command
        # @return [void]
        def exec(command)
            @logger.log '===> ' + command
            @logger.log `#{command}`
        end

    end

end
