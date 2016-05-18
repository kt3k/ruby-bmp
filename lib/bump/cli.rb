require 'bump/version'
require 'yaml'

module Bump
  # The command line interface
  class CLI
    attr_reader :app

    # The bump info filename
    VERSION_FILE = '.bmp.yml'.freeze

    # The cli name
    CLI_NAME = 'bmp'.freeze

    def initialize(opts)
      @app = Application.new opts.to_hash, opts.to_s, "#{CLI_NAME} v#{Bump::VERSION}", VERSION_FILE, Logger.new
    end

    # The main of cli
    def main
      @app.main
    end
  end
end
