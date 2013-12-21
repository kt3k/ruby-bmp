

module Bump

    class Command

        def initialize logger
            @logger = logger
        end

        def exec command
            @logger.log "===> " + command
            @logger.log `#{command}`
        end

    end

end
