# bump_spec.rb

require 'bump'

describe Bump::Version do

    describe "#initialize" do

        it "constructs" do

            expect(Bump::Version.new('1', '2', '3')).not_to be_nil

        end

    end

    describe "#to_s" do

        it "returns version string" do

            version = Bump::Version.new '1', '2', '3'

            expect(version.to_s).to eq '1.2.3'

        end

    end

end
