
require 'bump'
require 'spec_helper'

describe Bump::BumpInfoRepository do

    describe '#fromFile' do

        it 'gets the bump info from the file' do

            repo = Bump::BumpInfoRepository.new 'spec/fixture/bmp.yml'

            bump_info = repo.fromFile

            expect(bump_info.class).to eq Bump::BumpInfo

        end

    end

    describe '#save' do

        it 'saves the current info to the file' do

            repo = Bump::BumpInfoRepository.new 'spec/fixture/bmp.yml'

            bump_info = repo.fromFile
            bump_info = Bump::BumpInfo.new Bump::VersionNumber.new(1, 2, 4), bump_info.files, bump_info.commit

            repo.save bump_info

            bump_info = repo.fromFile
            expect(bump_info.version.to_s).to eq '1.2.4'

        end

    end

end
