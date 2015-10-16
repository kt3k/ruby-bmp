
require 'bump'
require 'spec_helper'

describe Bump::FileUpdateRuleFactory do

    describe 'self.create' do

        it 'creates a FileUpdateRule if the give param is string' do

            rule = Bump::FileUpdateRuleFactory.create 'README.md', 'v%.%.%', '1.2.3', '2.0.0'

            expect(rule.class).to eq Bump::FileUpdateRule

        end

        it 'craetes a list of FileUpdateRules if the give param is an array of string' do

            rules = Bump::FileUpdateRuleFactory.create 'READEME.md', ['v%.%.%', 'w%.%.%'], '1.2.3', '2.0.0'

            expect(rules.class).to eq Array
            expect(rules[0].class).to eq Bump::FileUpdateRule
            expect(rules[1].class).to eq Bump::FileUpdateRule
            expect(rules.size).to eq 2
        end

        it 'creates a FileUpdateRule if the given param is not a string nor an array' do

            rule = Bump::FileUpdateRuleFactory.create 'READEME.md', nil, '1.2.3', '2.0.0'

            expect(rule.class).to eq Bump::FileUpdateRule

        end

    end

end
