
require 'bump'
require 'spec_helper'

describe Bump::FileUpdateRule do

    describe '#file' do

        it 'returns file property' do
            rule = Bump::FileUpdateRule.new 'abc', '%.%.%', '0.0.1', '1.0.0'

            expect(rule.file).to eq 'abc'
        end

    end

    describe '#beforePattern' do

        it 'returns before_pattern property' do
            rule = Bump::FileUpdateRule.new 'abc', 'v%.%.%', '0.0.1', '1.0.0'

            expect(rule.beforePattern).to eq 'v0.0.1'
        end

    end

    describe '#afterPattern' do

        it 'returns before_pattern property' do
            rule = Bump::FileUpdateRule.new 'abc', 'v%.%.%', '0.0.1', '1.0.0'

            expect(rule.afterPattern).to eq 'v1.0.0'
        end

    end

    describe '#patternExists' do

        it 'checks if the given pattern found in the file' do

            rule = Bump::FileUpdateRule.new 'spec/fixture/dummy.txt', 'v%.%.%', '1.2.3', '2.0.0'

            expect(rule.patternExists).to eq true

        end

    end

end
