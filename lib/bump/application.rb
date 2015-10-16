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
            @logger.log @version
        end

        def actionHelp
            @logger.log @help
        end

        def actionInfo
            repo = VersionDescriptorRepository.new @file

            begin
                descriptor = repo.fromFile
            rescue Errno::ENOENT => e then
                @logger.log "Error: the file `#{@file}` not found."
                exit 1
            end

            @logger.log "Current Version is:", false
            @logger.log_green " #{descriptor.beforeVersion}"

            @logger.log "Replacement target patterns are:"

            descriptor.rewriteRules.each do |rule|
                rule.prepare

                @logger.log "  #{rule.file}:", false
                @logger.log_green " '#{rule.beforePattern}'"
            end
        end

        def actionBump

            repo = VersionDescriptorRepository.new @file

            begin
                srv = repo.fromFile
            rescue Errno::ENOENT => e then
                @logger.log "Error: the file `#{@file}` not found."
                exit 1
            end

            if @options[:patch]
                srv.patchBump

                @logger.log 'Bump patch level'
                @logger.log_green "  #{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if @options[:minor]
                srv.minorBump

                @logger.log 'Bump minor level'
                @logger.log_green "  #{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if @options[:major]
                srv.majorBump

                @logger.log 'Bump major level'
                @logger.log_green "  #{srv.beforeVersion} => #{srv.afterVersion}"
            end

            @logger.log

            srv.rewriteRules.each do |rule|
                result = rule.perform

                if result
                    @logger.log "#{rule.file}"
                    @logger.log "  Performed pattern replacement:"
                    @logger.log_green "    '#{rule.beforePattern}' => '#{rule.afterPattern}'"
                    @logger.log
                else
                    @logger.log_red "  Current version pattern ('#{rule.beforePattern}') not found!"
                    @logger.log

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
            @logger.error @error_message
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

    end

end
