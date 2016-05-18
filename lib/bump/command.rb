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
      @logger.log @logger.green('+' + command)
      @logger.log `#{command}`, nil
    end
  end
end
