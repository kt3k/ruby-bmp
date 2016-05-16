
require 'spec_helper'
require 'bump'

describe Bump::Application do

    before :each do

        @help_message = 'help_message'
        @version_exp = "Bmp #{Bump::VERSION}"
        @bmp_file = 'spec/fixture/bmp.yml'
        @logger = Bump::Logger.new

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

end
