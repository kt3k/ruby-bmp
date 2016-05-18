require 'bump'
require 'spec_helper'

describe Bump::VersionNumberFactory do
  describe '#from_string' do
    it 'creates version object from version string' do
      version = Bump::VersionNumberFactory.from_string '1.2.3-a'

      expect(version.to_s).to eq '1.2.3-a'

      version = Bump::VersionNumberFactory.from_string '1.2.100-abc'

      version.bump :patch

      expect(version.to_s).to eq '1.2.101'
    end
  end
end
