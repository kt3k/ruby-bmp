
require 'spec_helper'
require 'bump'

describe Bump::Application do

    before :each do

        @help_message = 'help_message'
        @version_exp = "Bmp #{Bump::VERSION}"
        @bmp_file = 'spec/fixture/bmp.yml'

        @logger = double 'logger'
        allow(@logger).to receive(:log)
        allow(@logger).to receive(:green)
        allow(@logger).to receive(:red)

    end

    describe 'selectAction' do

        it 'returns :help if the options contain :help' do

            app = Bump::Application.new({ help: true }, @help_message, @version_exp, @bmp_file, @logger)

            expect(app.selectAction).to eq :help

        end

        it 'returns :version if the :version option preset' do

            app = Bump::Application.new({ version: true }, @help_message, @version_exp, @bmp_file, @logger)

            expect(app.selectAction).to eq :version

        end

        it 'returns :info if the :info option present' do

            app = Bump::Application.new({ info: true }, @help_message, @version_exp, @bmp_file, @logger)

            expect(app.selectAction).to eq :info

        end

        it 'returns :bump if one of :major, :minor, :patch, :commit, :preid, :release options present' do

            app = Bump::Application.new({ major: true }, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.selectAction).to eq :bump

            app = Bump::Application.new({ minor: true }, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.selectAction).to eq :bump

            app = Bump::Application.new({ patch: true }, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.selectAction).to eq :bump

            app = Bump::Application.new({ commit: true }, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.selectAction).to eq :bump

            app = Bump::Application.new({ preid: true }, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.selectAction).to eq :bump

            app = Bump::Application.new({ release: true }, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.selectAction).to eq :bump

        end

        it 'returns :info if none of the above options are present' do

            app = Bump::Application.new({}, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.selectAction).to eq :info

        end

    end

    describe '#main' do

        it 'logs version when the version option is given' do

            expect(@logger).to receive(:log).with("Bmp #{Bump::VERSION}", true).once

            app = Bump::Application.new({ version: true }, @help_message, @version_exp, @bmp_file, @logger)
            app.main

        end

        it 'logs help message when the help option is given' do

            expect(@logger).to receive(:log).with('help_message', true).once

            app = Bump::Application.new({ help: true }, @help_message, @version_exp, @bmp_file, @logger)
            app.main

        end

        it 'shows bump info and exit 0 when there is no error' do

            app = Bump::Application.new({ info: true }, @help_message, @version_exp, @bmp_file, @logger)
            allow(app).to receive(:exit)

            expect(app).to receive(:exit).with(0).once

            app.main

        end

        it 'shows bump info and exit 1 when there are errors' do

            app = Bump::Application.new({ info: true }, @help_message, @version_exp, 'spec/fixture/bmp_invalid.yml', @logger)

            expect(app).to receive(:exit).with(1).once

            app.main

        end

        it 'exits 1 when the pattern in bmp.yml not found' do
            app = Bump::Application.new({ info: true }, @help_message, @version_exp, 'spec/fixture/bmp_invalid_pattern.yml', @logger)

            expect(app).to receive(:exit).with(1).once
            allow(app).to receive(:exit) { throw StandardError.new }

            expect { app.main }.to raise_error(StandardError)
        end

        it 'exits 1 when the bmp.yml not found' do
            app = Bump::Application.new({ info: true }, @help_message, @version_exp, 'spec/fixture/bmp_not_exists.yml', @logger)

            expect(app).to receive(:exit).with(1).once
            allow(app).to receive(:exit) { throw StandardError.new }

            expect { app.main }.to raise_error(StandardError)
        end
    end
end
