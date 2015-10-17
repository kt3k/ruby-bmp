
require 'bump'
require 'spec_helper'

describe Bump::FileUpdateRule do

    before :each do
        @rule = Bump::FileUpdateRule.new 'spec/fixture/dummy.txt', 'v%.%.%', '1.2.3', '2.0.0'
    end

    describe '#file' do

        it 'returns file property' do

            expect(@rule.file).to eq 'spec/fixture/dummy.txt'

        end

    end

    describe '#beforePattern' do

        it 'returns before_pattern property' do

            expect(@rule.beforePattern).to eq 'v1.2.3'

        end

    end

    describe '#afterPattern' do

        it 'returns before_pattern property' do

            expect(@rule.afterPattern).to eq 'v2.0.0'

        end

    end

    describe '#patternExists' do

        it 'checks if the given pattern found in the file' do

            expect(@rule.patternExists).to be true

        end

    end

end
