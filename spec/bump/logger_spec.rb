require 'bump'
require 'spec_helper'

describe Bump::Logger do
    before :each do
        @logger = Bump::Logger.new
    end

    describe '#log' do
        it 'logs message' do
            expect(@logger).to receive(:print).with('foo').once
            expect(@logger).to receive(:print).with("\n").once

            @logger.log 'foo'
        end
    end

    describe '#green' do
        it 'returns green text' do
            expect(@logger.green('text')).to eq "\e[32mtext\e[0m"
        end

        it 'retruns no color text when the no_color option is true' do
            @logger = Bump::Logger.new true

            expect(@logger.green('text')).to eq 'text'
        end
    end

    describe '#red' do
        it 'returns red text' do
            expect(@logger.red('text')).to eq "\e[31mtext\e[0m"
        end
    end
end
