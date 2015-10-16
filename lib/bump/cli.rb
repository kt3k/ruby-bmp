
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

            opts = Slop.parse do |o|
                o.banner = "Usage: #{CLI_NAME} [-p|-m|-j] [-c]"

                o.bool '-i', '--info', 'show current version info'
                o.bool '-p', '--patch', 'bump patch (0.0.1) level'
                o.bool '-m', '--minor', 'bump minor (0.1.0) level'
                o.bool '-j', '--major', 'bump major (1.0.0) level'
                o.bool '-c', '--commit', 'commit bump changes (git required)'
                o.bool '-h', '--help', 'show this help and exit'
                o.bool '-v', '--version', 'show the version of this command and exit'
                o.bool '-r', '--release', 'remove the pre-release version id'
                o.string '-s', '--preid', 'set the pre-release version id (e.g. alpha, beta.1)'
            end

            app = Application.new opts.to_hash, opts.to_s, "#{CLI_NAME} v#{Bump::VERSION}", VERSION_FILE, Logger.new

            app.main

        end

    end

end
