
require 'bump'
require 'spec_helper'

describe Bump::FileRewriteRule do

    describe '#file' do

        it 'returns file property' do
            rule = Bump::FileRewriteRule.new 'abc', '%.%.%', '0.0.1', '1.0.0'

            expect(rule.file).to eq 'abc'
        end

    end

    describe '#beforePattern' do

        it 'returns before_pattern property' do
            rule = Bump::FileRewriteRule.new 'abc', 'v%.%.%', '0.0.1', '1.0.0'

            rule.prepare

            expect(rule.beforePattern).to eq 'v0.0.1'
        end

    end

    describe '#afterPattern' do

        it 'returns before_pattern property' do
            rule = Bump::FileRewriteRule.new 'abc', 'v%.%.%', '0.0.1', '1.0.0'

            rule.prepare

            expect(rule.afterPattern).to eq 'v1.0.0'
        end

    end

end
