
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
        it 'logs version and returns true when the version option is given' do
            expect(@logger).to receive(:log).with("Bmp #{Bump::VERSION}", true).once

            app = Bump::Application.new({ version: true }, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.main).to be true
        end

        it 'logs help message and returns true when the help option is given' do
            expect(@logger).to receive(:log).with('help_message', true).once

            app = Bump::Application.new({ help: true }, @help_message, @version_exp, @bmp_file, @logger)
            expect(app.main).to be true
        end

        it 'shows bump info and return true when there is no error' do
            app = Bump::Application.new({ info: true }, @help_message, @version_exp, @bmp_file, @logger)

            expect(app.main).to be true
        end

        it 'shows bump info and returns false when there are errors' do
            app = Bump::Application.new({ info: true }, @help_message, @version_exp, 'spec/fixture/bmp_invalid.yml', @logger)

            expect(app.main).to be false
        end

        it 'returns false when the pattern in bmp.yml is invalid' do
            app = Bump::Application.new({ info: true }, @help_message, @version_exp, 'spec/fixture/bmp_invalid_pattern.yml', @logger)

            expect(app.main).to be false
        end

        it 'returns false when the bmp.yml not found' do
            app = Bump::Application.new({ info: true }, @help_message, @version_exp, 'spec/fixture/bmp_not_exists.yml', @logger)

            expect(app.main).to be false
        end

        describe 'with :major|:minor|:patch|:preid|:release options' do
            it 'returns false when the pattern in bmp.yml is invalid' do
                app = Bump::Application.new({ major: true }, @help_message, @version_exp, 'spec/fixture/bmp_invalid_pattern.yml', @logger)

                expect(app.main).to be false

                app = Bump::Application.new({ minor: true }, @help_message, @version_exp, 'spec/fixture/bmp_invalid_pattern.yml', @logger)

                expect(app.main).to be false

                app = Bump::Application.new({ patch: true }, @help_message, @version_exp, 'spec/fixture/bmp_invalid_pattern.yml', @logger)

                expect(app.main).to be false

                app = Bump::Application.new({ preid: 'beta.1' }, @help_message, @version_exp, 'spec/fixture/bmp_invalid_pattern.yml', @logger)

                expect(app.main).to be false

                app = Bump::Application.new({ release: true }, @help_message, @version_exp, 'spec/fixture/bmp_invalid_pattern.yml', @logger)

                expect(app.main).to be false
            end

            it 'returns true when no error found' do
                File.write 'spec/fixture/tmp_bmp_tmp.yml', File.read('spec/fixture/bmp_tmp.yml', encoding: Encoding::UTF_8)
                File.write 'spec/fixture/tmp_dummy.txt', File.read('spec/fixture/dummy.txt', encoding: Encoding::UTF_8)

                app = Bump::Application.new({ patch: true }, @help_message, @version_exp, 'spec/fixture/tmp_bmp_tmp.yml', @logger)

                expect(app.main).to be true

                File.delete 'spec/fixture/tmp_bmp_tmp.yml'
                File.delete 'spec/fixture/tmp_dummy.txt'
            end
        end
    end
end
