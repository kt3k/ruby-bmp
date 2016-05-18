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

  describe '#file_exists' do
    it 'returns true if file exists' do
      expect(@rule.file_exists).to be true
    end

    it 'returns false if file does not exist' do
      @rule = Bump::FileUpdateRule.new 'spec/fixture/doesnotexist.txt', 'v%.%.%', '1.2.3', '2.0.0'

      expect(@rule.file_exists).to be false
    end
  end

  describe '#pattern_exists' do
    it 'checks if the given pattern found in the file' do
      expect(@rule.pattern_exists).to be true
    end
  end

  describe '#perform' do
    it 'performs the pattern replacement in the file' do
      @rule.perform

      expect(File.read('spec/fixture/tmp_dummy.txt', encoding: Encoding::UTF_8).strip).to eq 'dummy v2.0.0-rc1'
    end
  end
end
