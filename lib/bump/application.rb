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
        def select_action
            return :help if @options[:help]

            return :version if @options[:version]

            return :info if @options[:info]

            return :bump if bump_option? @options

            # command without options invokes info action
            :info
        end

        # Returns true iff it's a bump option.
        # @param [Hash] options The options
        def bump_option?(options)
            options[:major] || options[:minor] || options[:patch] || options[:commit] || options[:preid] || options[:release]
        end

        # handler of `bmp --version`
        #
        # @return [void]
        def action_version
            log @version

            true
        end

        # handler of `bmp --help`
        #
        # @return [void]
        def action_help
            log @help

            true
        end

        # Gets the bump info
        # @private
        # @return [Bump::BumpInfo]
        def create_bump_info
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
        def save_bump_info(bump_info)
            repo = BumpInfoRepository.new @file

            repo.save bump_info
        end

        # Shows the version patterns.
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def print_version_patterns(bump_info)
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
        def action_info
            bump_info = create_bump_info

            return false if bump_info.nil?

            print_version_patterns bump_info

            bump_info.valid?
        end

        # Checks the bumping is possible.
        # @param [Bump::BumpInfo] bumpInfo
        # @return [void]
        def print_invalid_bump_info(bump_info)
            log_red 'Some patterns are invalid!'
            log_red 'Stops updating version numbers.'
            log

            print_version_patterns bump_info
        end

        # Reports the bumping details.
        # @param [Bump::BumpInfo] bumpInfo
        def report(bump_info)
            bump_info.updateRules.each do |rule|
                log rule.file.to_s
                log '  Performed pattern replacement:'
                log_green "    '#{rule.beforePattern}' => '#{rule.afterPattern}'"
                log
            end
        end

        # The bump action
        # @return [Boolean] true iff success
        def action_bump
            bump_info = create_bump_info

            return false if bump_info.nil?

            print_bump_plan bump_info

            unless bump_info.valid?
                print_invalid_bump_info bump_info

                return false
            end

            bump_info.performUpdate

            report bump_info

            save_bump_info bump_info

            commit_and_tag bump_info if @options[:commit]

            true
        end

        # Gets the requested bump level.
        # @return [Symbol]
        def bump_level
            return :major if @options[:major]
            return :minor if @options[:minor]
            return :patch if @options[:patch]
        end

        # Prints the version bump plan.
        # @param [Bump::BumpInfo] bump_info The bump info
        def print_bump_plan(bump_info)
            level = bump_level
            print_bump_plan_level level, bump_info unless level.nil?

            preid = @options[:preid]
            print_bump_plan_preid preid, bump_info unless preid.nil?

            print_bump_plan_release bump_info if @options[:release]

            log
        end

        # Prints the bump plan for the given level.
        # @param [Symbol] level The level
        # @param [Bump::BumpInfo] bump_info The bump info
        def print_bump_plan_level(level, bump_info)
            bump_info.bump level

            log "Bump #{level} level"
            print_version_transition bump_info
        end

        # Prints the bump plan for the give preid.
        # @param [Bump::BumpInfo] bump_info The bump info
        def print_bump_plan_preid(preid, bump_info)
            bump_info.setPreid preid

            log 'Set pre-release version id: ', false
            log_green preid
            print_version_transition bump_info
        end

        # Prints the bump plan for the release
        # @param [Bump::BumpInfo] bump_info The bump info
        def print_bump_plan_release(bump_info)
            bump_info.setPreid nil

            log 'Remove pre-release version id'
            print_version_transition bump_info
        end

        # Prints the version transition.
        # @param [Bump::BumpInfo] bump_info The bump info
        def print_version_transition(bump_info)
            log_green "  #{bump_info.before_version} => #{bump_info.after_version}"
        end

        # Commits current changes and tag it by the current version.
        # @param [Bump::BumpInfo] bump_info The bump info
        def commit_and_tag(bump_info)
            @logger.log '===> executing commands'
            @command.exec 'git add .'
            @command.exec "git commit -m '#{bump_info.getCommitMessage}'"
            @command.exec "git tag v#{bump_info.after_version}"
        end

        # The entry point
        #
        # @return [void]
        def main
            case select_action
            when :version
                action_version
            when :help
                action_help
            when :info
                action_info
            when :bump
                action_bump
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
