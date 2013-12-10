# bump_spec.rb

require 'bump'

describe Bump::Version do

    describe "#initialize" do

        it "constructs" do

            expect(Bump::Version.new('1', '2', '3')).not_to be_nil

        end

    end

end
