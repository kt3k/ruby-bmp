require 'bump'
require 'spec_helper'

describe Bump::CLI do
    describe '#main' do
        it 'calls app.main' do
            cli = Bump::CLI.new({})

            expect(cli.app).to receive(:main).once

            cli.main
        end
    end
end
