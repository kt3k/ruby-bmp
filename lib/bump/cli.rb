
require 'bump/version'
require 'yaml'
require 'slop'

module Bump

    # The command line interface
    class CLI

        # The bump info filename
        VERSION_FILE = '.bmp.yml'

        # The cli name
        CLI_NAME = 'bmp'

        # The main routine
        #
        # @return [void]
        def main

            opts = Slop.parse do
                banner "Usage: #{CLI_NAME} [-p|-m|-j] [-c]"

                on :i, :info, 'show current version info'
                on :p, :patch, 'bump patch (0.0.1) level'
                on :m, :minor, 'bump minor (0.1.0) level'
                on :j, :major, 'bump major (1.0.0) level'
                on :c, :commit, 'commit bump changes (git required)'
                on :h, :help, 'show this help and exit'
                on :v, :version, 'show version and exit'
            end

            app = Application.new opts.to_hash, opts.to_s, "#{CLI_NAME} v#{Bump::VERSION}", VERSION_FILE, Logger.new

            app.main

        end

    end

end
