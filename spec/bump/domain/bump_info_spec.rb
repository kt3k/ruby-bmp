require 'bump'
require 'spec_helper'

describe Bump::BumpInfo do
  before :each do
    @info = Bump::BumpInfo.new Bump::VersionNumber.new(1, 2, 3), { 'README.md' => 'v%.%.%', 'package.json' => 'v%.%.%' }, nil
  end

  describe '#commit_message' do
    it 'gets the commit message' do
      @info = Bump::BumpInfo.new Bump::VersionNumber.new(1, 2, 3), { 'README.md' => 'v%.%.%', 'package.json' => 'v%.%.%' }, 'chore(bump): v%.%.%'

      expect(@info.commit_message).to eq 'chore(bump): v1.2.3'
    end
  end

  describe '#bump' do
    it 'bumps the version with the give level' do
      @info.bump :patch
      expect(@info.version.to_s).to eq '1.2.4'

      @info.bump :minor
      expect(@info.version.to_s).to eq '1.3.0'

      @info.bump :major
      expect(@info.version.to_s).to eq '2.0.0'
    end
  end

  describe '#preid=' do
    it 'sets the preid' do
      @info.preid = 'beta.1'

      expect(@info.version.to_s).to eq '1.2.3-beta.1'
    end
  end

  describe '#update_rules' do
    it 'gets the file update rules' do
      expect(@info.update_rules.class).to eq Array
      expect(@info.update_rules.size).to eq 2
      expect(@info.update_rules[0].class).to eq Bump::FileUpdateRule
      expect(@info.update_rules[1].class).to eq Bump::FileUpdateRule
    end
  end

  describe '#perform_update' do
    it 'performs the update on files' do
      File.write 'spec/fixture/tmp_dummy.txt', File.read('spec/fixture/dummy.txt', encoding: Encoding::UTF_8)

      @info = Bump::BumpInfo.new Bump::VersionNumber.new(1, 2, 3, 'rc1'), { 'spec/fixture/tmp_dummy.txt' => 'v%.%.%' }, nil

      @info.bump :patch

      @info.perform_update

      expect(File.read('spec/fixture/tmp_dummy.txt', encoding: Encoding::UTF_8).strip).to eq 'dummy v1.2.4'

      File.delete 'spec/fixture/tmp_dummy.txt'
    end
  end

  describe '#valid?' do
    it 'returns false if the files or petterns are unavailable' do
      expect(@info.valid?).to be false
    end

    it 'returns true if the files and patterns are available' do
      @info = Bump::BumpInfo.new Bump::VersionNumber.new(1, 2, 3, 'rc1'), { 'spec/fixture/dummy.txt' => 'v%.%.%' }, nil

      expect(@info.valid?).to be true
    end
  end
end
