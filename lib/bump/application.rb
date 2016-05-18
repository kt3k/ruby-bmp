require 'bump/command'

module Bump
    # The application
    class Application
        # @param [Hash] options The cli options
        # @param [String] help The help message
        # @param [String] version The version expression of this command
        # @param [String] file The file name of bump info file
        # @param [Bump::Logger] logger The logger
        # @param [Bump::Command] logger The command executer
        def initialize(options, help, version, file, logger, command = nil)
            @options = options
            @help = help
            @version = version
            @file = file
            @logger = logger
            @command = command
            @command = Bump::Command.new @logger if @command.nil?
        end

        # Returns a symbol which represents the action to perform.
        # @return [Symbol]
        def selectAction
            return :help if @options[:help]

            return :version if @options[:version]

            return :info if @options[:info]

            return :bump if @options[:major] || @options[:minor] || @options[:patch] || @options[:commit] || @options[:preid] || @options[:release]

            # command without options invokes info action
            :info
        end

        # handler of `bmp --version`
        #
        # @return [void]
        def actionVersion
            log @version

            true
        end

        # handler of `bmp --help`
        #
        # @return [void]
        def actionHelp
            log @help

            true
        end

        # Gets the bump info
        # @private
        # @return [Bump::BumpInfo]
        def getBumpInfo
            repo = BumpInfoRepository.new @file

            begin
                bump_info = repo.fromFile
            rescue Errno::ENOENT
                log_red "Error: the file `#{@file}` not found."
                return nil
            end

            bump_info
        end

        # Saves the bump info
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def saveBumpInfo(bump_info)
            repo = BumpInfoRepository.new @file

            repo.save bump_info
        end

        # Shows the version patterns.
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def showVersionPatterns(bump_info)
            log 'Current Version:', false
            log_green " #{bump_info.before_version}"

            log 'Version patterns:'

            bump_info.updateRules.each do |rule|

                print_rule rule

            end
        end

        # Prints the pattern info for the given rule
        # @param [Bump::FileUpdateRule] rule The rule
        def print_rule(rule)
            unless rule.fileExists

                log_red "  #{rule.file}:", false
                log_red " '#{rule.beforePattern}' (file not found)"

                return

            end

            log "  #{rule.file}:", false

            unless rule.patternExists

                log_red " '#{rule.beforePattern}' (pattern not found)"

                return

            end

            log_green " '#{rule.beforePattern}'"
        end

        # handler of `bmp [--info]`
        #
        # @return [void]
        def actionInfo
            bump_info = getBumpInfo

            return false if bump_info.nil?

            showVersionPatterns bump_info

            bump_info.valid?
        end

        # Checks the bumping is possible.
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def print_invalid_bump_info(bump_info)
            log_red 'Some patterns are invalid!'
            log_red 'Stops updating version numbers.'
            log

            showVersionPatterns bump_info
        end

        # Reports the bumping details.
        #
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def report(bump_info)
            bump_info.updateRules.each do |rule|

                log rule.file.to_s
                log '  Performed pattern replacement:'
                log_green "    '#{rule.beforePattern}' => '#{rule.afterPattern}'"
                log

            end
        end

        # handler of `bmp --patch|--minor|--major|--commit`
        #
        # @return [void]
        def actionBump
            bump_info = getBumpInfo

            return false if bump_info.nil?

            [:major, :minor, :patch].each do |level|

                next unless @options[level]

                bump_info.bump level
                log "Bump #{level} level"
                log_green "  #{bump_info.before_version} => #{bump_info.after_version}"
                break

            end

            if @options[:preid]
                preid = @options[:preid]
                bump_info.setPreid preid
                log 'Set pre-release version id: ', false
                log_green preid
                log_green "  #{bump_info.before_version} => #{bump_info.after_version}"
            end

            if @options[:release]
                bump_info.setPreid nil
                log 'Remove pre-release version id'
                log_green "  #{bump_info.before_version} => #{bump_info.after_version}"
            end

            log

            unless bump_info.valid?
                print_invalid_bump_info bump_info

                return false
            end

            bump_info.performUpdate

            report bump_info

            saveBumpInfo bump_info

            if @options[:commit]
                @logger.log '===> executing commands'
                @command.exec 'git add .'
                @command.exec "git commit -m '#{bump_info.getCommitMessage}'"
                @command.exec "git tag v#{bump_info.after_version}"
            end

            true
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
        def log(message = '', newline = true)
            @logger.log message, newline
        end

        # Logs the message in red
        #
        # @param [String] message
        # @param [Boolean] newline
        # @return [void]
        def log_red(message, newline = true)
            log @logger.red(message), newline
        end

        # Logs the message in green
        #
        # @param [String] message
        # @param [Boolean] newline
        # @return [void]
        def log_green(message, newline = true)
            log @logger.green(message), newline
        end
    end
end
