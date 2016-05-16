require 'bump'
require 'spec_helper'

describe Bump::FileUpdateRule do

    before :each do

        File.write 'spec/fixture/tmp_dummy.txt', File.read('spec/fixture/dummy.txt', encoding: Encoding::UTF_8)

        @rule = Bump::FileUpdateRule.new 'spec/fixture/tmp_dummy.txt', 'v%.%.%', '1.2.3', '2.0.0'

    end

    after :each do

        File.delete 'spec/fixture/tmp_dummy.txt'

    end

    describe '#file' do

        it 'returns file property' do

            expect(@rule.file).to eq 'spec/fixture/tmp_dummy.txt'

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

    describe '#fileExists' do

        it 'returns true if file exists' do

            expect(@rule.fileExists).to be true

        end

        it 'returns false if file does not exist' do

            @rule = Bump::FileUpdateRule.new 'spec/fixture/doesnotexist.txt', 'v%.%.%', '1.2.3', '2.0.0'

            expect(@rule.fileExists).to be false

        end

    end

    describe '#patternExists' do

        it 'checks if the given pattern found in the file' do

            expect(@rule.patternExists).to be true

        end

    end

    describe '#perform' do

        it 'performs the pattern replacement in the file' do

            @rule.perform

            expect(File.read('spec/fixture/tmp_dummy.txt', encoding: Encoding::UTF_8).strip).to eq 'dummy v2.0.0-rc1'

        end

    end

end
