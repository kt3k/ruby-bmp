# bump_spec.rb

require 'bump'
require 'spec_helper'

describe Bump::Version do

    describe "#initialize" do

        it "constructs" do

            expect(Bump::Version.new(1, 2, 3)).not_to be_nil

        end

    end

    describe "#to_s" do

        it "returns version string" do

            # no suffix
            version = Bump::Version.new 1, 2, 3

            expect(version.to_s).to eq '1.2.3'

            # with a suffix
            version = Bump::Version.new 1, 2, 3, 'rc1'

            expect(version.to_s).to eq '1.2.3rc1'

        end

    end

    describe "#patchBump" do

        it "bumps patch level" do

            version = Bump::Version.new 1, 2, 3

            version.patchBump

            expect(version.to_s).to eq '1.2.4'

        end

        it "remove suffix if it is set" do

            version = Bump::Version.new 1, 2, 3, 'rc1'

            version.patchBump

            expect(version.to_s).to eq '1.2.4'

        end

    end

    describe "#minorBump" do

        it "bumps patch level" do

            version = Bump::Version.new 1, 2, 3

            version.minorBump

            expect(version.to_s).to eq '1.3.0'

        end

        it "remove suffix if it is set" do

            version = Bump::Version.new 1, 2, 3, 'rc1'

            version.minorBump

            expect(version.to_s).to eq '1.3.0'

        end

    end

    describe "#majorBump" do

        it "bumps patch level" do

            version = Bump::Version.new 1, 2, 3

            version.majorBump

            expect(version.to_s).to eq '2.0.0'

        end

        it "remove suffix if it is set" do

            version = Bump::Version.new 1, 2, 3, 'rc1'

            version.majorBump

            expect(version.to_s).to eq '2.0.0'

        end

    end

    describe "#append" do

        it "appends a suffix" do

            version = Bump::Version.new 1, 2, 3

            version.append 'rc1'

            expect(version.to_s).to eq '1.2.3rc1'

        end

        it "rewrite the suffix if it is already set" do

            version = Bump::Version.new 1, 2, 3, 'rc1'

            version.append 'rc2'

            expect(version.to_s).to eq '1.2.3rc2'

        end

    end

end
