
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

end
