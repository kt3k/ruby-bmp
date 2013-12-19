# lib/bump/application.rb

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

            if !@options[:major] && !@options[:minor] && !@options[:patch] && !@options[:fix]
                return :help
            end

            return :bump
        end

        def actionVersion
            @logger.log @version
        end

        def actionHelp
            @logger.log @help
        end

        def actionInfo
            repo = VersionDescriptorRepository.new @file

            descriptor = repo.fromFile

            @logger.log "Current Version: #{descriptor.beforeVersion}"

            @logger.log

            descriptor.rewriteRules.each do |rule|
                rule.prepare

                @logger.log "File: #{rule.file}"
                @logger.log "Pattern: #{rule.beforePattern}"
                @logger.log
            end
        end

        def actionBump

            repo = VersionDescriptorRepository.new @file

            srv = repo.fromFile

            if @options[:patch]
                srv.patchBump

                @logger.log 'Bump patch level'
                @logger.log "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if @options[:minor]
                srv.minorBump

                @logger.log 'Bump minor level'
                @logger.log "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            if @options[:major]
                srv.majorBump

                @logger.log 'Bump major level'
                @logger.log "#{srv.beforeVersion} => #{srv.afterVersion}"
            end

            @logger.log

            srv.rewriteRules.each do |rule|
                result = rule.perform

                if result
                    @logger.log "#{rule.file}"
                    @logger.log "  Performed pattern replacement:"
                    @logger.log "  '#{rule.beforePattern}' => '#{rule.afterPattern}'"
                    @logger.log
                else
                    @logger.log "  Current version pattern ('#{rule.beforePattern}') not found!"
                    @logger.log
                end
            end

            repo.save srv

            if @options[:fix]
                @logger.log `git add . ; git commit -m "Bump to version v#{srv.afterVersion}"`
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
