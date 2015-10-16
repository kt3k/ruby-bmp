
require 'bump'
require 'spec_helper'

describe Bump::VersionNumberFactory do

    describe "#fromString" do

        it "creates version object from version string" do

            version = Bump::VersionNumberFactory.fromString "1.2.3a"

            expect(version.to_s).to eq "1.2.3a"

            version.patchBump

            expect(version.to_s).to eq "1.2.4"

            version.minorBump

            expect(version.to_s).to eq "1.3.0"

            version.majorBump

            expect(version.to_s).to eq "2.0.0"

            version.append 'rc1'

            expect(version.to_s).to eq "2.0.0rc1"

            version = Bump::VersionNumberFactory.fromString "1.2.100abc"

            version.patchBump

            expect(version.to_s).to eq "1.2.101"

        end

    end

end
