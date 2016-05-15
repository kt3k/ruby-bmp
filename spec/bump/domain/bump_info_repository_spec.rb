
require 'bump'
require 'spec_helper'

describe Bump::BumpInfoRepository do

    describe '#fromFile' do

        it 'gets the bump info from the file' do

            repo = Bump::BumpInfoRepository.new 'spec/fixture/bmp.yml'

            bumpInfo = repo.fromFile

            expect(bumpInfo.class).to eq Bump::BumpInfo

        end

    end

    describe '#save' do

        it 'saves the current info to the file' do

            repo = Bump::BumpInfoRepository.new 'spec/fixture/bmp.yml'

            bumpInfo = repo.fromFile
            bumpInfo = Bump::BumpInfo.new Bump::VersionNumber.new(1, 2, 4), bumpInfo.files, bumpInfo.commit

            repo.save bumpInfo

            bumpInfo = repo.fromFile
            expect(bumpInfo.version.to_s).to eq '1.2.4'

        end
    end

end
