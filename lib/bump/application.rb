# lib/bump/application.rb

require 'bump/command'

module Bump

    class Application

        # @param [Hash] options The cli options
        # @param [String] help The help message
        # @param [String] version The version expression of this command
        # @param [String] file The file name of bump info file
        # @param [Bump::Logger] logger The logger
        def initialize options, help, version, file, logger
            @options = options
            @help = help
            @version = version
            @file = file
            @logger = logger
        end

        # Select the main action
        #
        # @return [Symbol]
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

        # handler of `bmp --version`
        def actionVersion
            log @version
        end

        # handler of `bmp --help`
        def actionHelp
            log @help
        end

        # Gets the bump info
        #
        # @return [Bump::BumpInfo]
        def getBumpInfo

            repo = BumpInfoRepository.new @file

            begin
                bumpInfo = repo.fromFile
            rescue Errno::ENOENT => e then
                log_red "Error: the file `#{@file}` not found."
                exit 1
            end

            return bumpInfo

        end

        # Saves the bump info
        #
        # @param [Bump::BumpInfo] bumpInfo
        def saveBumpInfo bumpInfo
            repo = BumpInfoRepository.new @file

            repo.save bumpInfo
        end

        # Shows the version patterns.
        #
        # @param [Bump::BumpInfo] bumpInfo
        def showVersionPatterns bumpInfo

            log "Current Version:", false
            log_green " #{bumpInfo.beforeVersion}"

            log "Version patterns:"

            bumpInfo.updateRules.each do |rule|
                log "  #{rule.file}:", false

                if rule.patternExists
                    log_green " '#{rule.beforePattern}'"
                else
                    log_red " '#{rule.beforePattern}' (pattern not found)"
                end
            end

        end

        # handler of `bmp [--info]`
        def actionInfo

            bumpInfo = getBumpInfo

            showVersionPatterns bumpInfo

            if bumpInfo.check
                exit 0
            else
                exit 1
            end

        end

        # handler of `bmp --patch|--minor|--major|--commit`
        def actionBump

            bumpInfo = getBumpInfo

            if @options[:patch]
                bumpInfo.patchBump

                log 'Bump patch level'
                log_green "  #{bumpInfo.beforeVersion} => #{bumpInfo.afterVersion}"
            end

            if @options[:minor]
                bumpInfo.minorBump

                log 'Bump minor level'
                log_green "  #{bumpInfo.beforeVersion} => #{bumpInfo.afterVersion}"
            end

            if @options[:major]
                bumpInfo.majorBump

                log 'Bump major level'
                log_green "  #{bumpInfo.beforeVersion} => #{bumpInfo.afterVersion}"
            end

            log

            if not bumpInfo.check
                log_red "Some patterns are invalid!"
                log_red "Stops updating version numbers."
                log

                showVersionPatterns bumpInfo

                exit 1
            end

            bumpInfo.performUpdate

            bumpInfo.updateRules.each do |rule|

                log "#{rule.file}"
                log "  Performed pattern replacement:"
                log_green "    '#{rule.beforePattern}' => '#{rule.afterPattern}'"
                log

            end

            saveBumpInfo bumpInfo

            comm = Command.new @logger

            if @options[:commit]
                comm.exec "git add ."
                comm.exec "git commit -m 'Bump to version v#{bumpInfo.afterVersion}'"
                comm.exec "git tag v#{bumpInfo.afterVersion}"
            end
        end

        # The entry point
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
            end

        end

        # Logs the message
        #
        # @param [String] message
        # @param [Boolean] newline
        def log message = '', newline = true

            @logger.log message, newline

        end

        # Logs the message in red
        #
        # @param [String] message
        # @param [Boolean] newline
        def log_red message, newline = true

            @logger.log_red message, newline

        end

        # Logs the message in green
        #
        # @param [String] message
        # @param [Boolean] newline
        def log_green message, newline = true

            @logger.log_green message, newline

        end

    end

end
