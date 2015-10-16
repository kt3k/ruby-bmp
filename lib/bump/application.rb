# lib/bump/application.rb

require 'bump/command'

module Bump

    # The application
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

        # Returns a symbol which represents the action to perform.
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
        #
        # @return [void]
        def actionVersion
            log @version
        end

        # handler of `bmp --help`
        #
        # @return [void]
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
        # @return [void]
        def saveBumpInfo bumpInfo
            repo = BumpInfoRepository.new @file

            repo.save bumpInfo
        end

        # Shows the version patterns.
        #
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
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
        #
        # @return [void]
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
        #
        # @return [void]
        def actionBump

            bumpInfo = getBumpInfo

            [:major, :minor, :patch].each do |level|
                if @options[level]
                    bumpInfo.bump level
                    log "Bump #{level} level"
                    log_green "  #{bumpInfo.beforeVersion} => #{bumpInfo.afterVersion}"
                    break
                end
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
        #
        # @return [void]
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
        # @return [void]
        def log message = '', newline = true

            @logger.log message, newline

        end

        # Logs the message in red
        #
        # @param [String] message
        # @param [Boolean] newline
        # @return [void]
        def log_red message, newline = true

            @logger.log_red message, newline

        end

        # Logs the message in green
        #
        # @param [String] message
        # @param [Boolean] newline
        # @return [void]
        def log_green message, newline = true

            @logger.log_green message, newline

        end

    end

end
