
require 'bump'
require 'spec_helper'

describe Bump::BumpInfo do

    before :each do

        @info = Bump::BumpInfo.new Bump::VersionNumber.new(1, 2, 3), { "README.md" => "v%.%.%", "package.json" => "v%.%.%" }

    end

    describe '#version' do

        it 'returns the version object' do

            expect(@info.version.class).to eq Bump::VersionNumber
            expect(@info.version.to_s).to eq '1.2.3'

        end

    end

    describe '#files' do

        it 'returns the hash of the files' do

            expect(@info.files).to eq({ "README.md" => "v%.%.%", "package.json" => "v%.%.%" })

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

end
