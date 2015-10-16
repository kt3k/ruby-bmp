# lib/bump/application.rb

require 'bump/command'

module Bump

    class Application

        def initialize options, help, version, file, logger
            @options = options
            @help = help
            @version = version
            @file = file
            @logger = logger
        end

        def selectAction
            if @options[:help]
                return :help
            end

            if @options[:version]
                return :version
            end

            if @options[:info]
                return :info
            end

            if @options[:major] || @options[:minor] || @options[:patch] || @options[:commit]
                return :bump
            end

            # command without options invokes info action
            return :info
        end

        def actionVersion
            log @version
        end

        def actionHelp
            log @help
        end

        def actionInfo
            repo = VersionDescriptorRepository.new @file

            begin
                descriptor = repo.fromFile
            rescue Errno::ENOENT => e then
                log_red "Error: the file `#{@file}` not found."
                exit 1
            end

            log "Current Version is:", false
            log_green " #{descriptor.beforeVersion}"

            log "Replacement target patterns are:"

            descriptor.rewriteRules.each do |rule|
                rule.prepare

                log "  #{rule.file}:", false
                log_green " '#{rule.beforePattern}'"
            end
        end

        def actionBump

            repo = VersionDescriptorRepository.new @file

            begin
                srv = repo.fromFile
            rescue Errno::ENOENT => e then

                log_red "Error: the file `#{@file}` not found."

                exit 1
            end

            if @options[:patch]
                srv.patchBump

                log 'Bump patch level'
                log_green "  #{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if @options[:minor]
                srv.minorBump

                log 'Bump minor level'
                log_green "  #{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if @options[:major]
                srv.majorBump

                log 'Bump major level'
                log_green "  #{srv.beforeVersion} => #{srv.afterVersion}"
            end

            log

            srv.rewriteRules.each do |rule|
                result = rule.perform

                if result
                    log "#{rule.file}"
                    log "  Performed pattern replacement:"
                    log_green "    '#{rule.beforePattern}' => '#{rule.afterPattern}'"
                    log
                else
                    log_red "  Current version pattern ('#{rule.beforePattern}') not found!"
                    log

                    exit 1
                end
            end

            repo.save srv

            comm = Command.new @logger

            if @options[:commit]
                comm.exec "git add ."
                comm.exec "git commit -m 'Bump to version v#{srv.afterVersion}'"
                comm.exec "git tag v#{srv.afterVersion}"
            end
        end

        def actionError
            log_red @error_message
        end

        def main

            action = selectAction

            case action
            when :version
                actionVersion
            when :help
                actionHelp
            when :info
                actionInfo
            when :bump
                actionBump
            when :error
                actionError
            end

        end

        def log message, newline = true

            @logger.log message, newline

        end

        def log_red message, newline = true

            @logger.log_red message, newline

        end

        def log_green message, newline = true

            @logger.log_green message, newline

        end

    end

end
