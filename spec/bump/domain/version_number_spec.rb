require 'bump'
require 'spec_helper'

describe Bump::VersionNumber do
    describe '#to_s' do
        it 'returns version string' do
            # no suffix
            version = Bump::VersionNumber.new 1, 2, 3

            expect(version.to_s).to eq '1.2.3'

            # with a suffix
            version = Bump::VersionNumber.new 1, 2, 3, 'rc1'

            expect(version.to_s).to eq '1.2.3-rc1'
        end
    end

    describe '#bump :patch' do
        it 'bumps patch level' do
            version = Bump::VersionNumber.new 1, 2, 3

            version.bump :patch

            expect(version.to_s).to eq '1.2.4'
        end

        it 'bumps 0.1.10 to 0.1.11' do
            version = Bump::VersionNumber.new 0, 1, 10

            version.bump :patch

            expect(version.to_s).to eq '0.1.11'
        end

        it 'remove suffix if it is set' do
            version = Bump::VersionNumber.new 1, 2, 3, 'rc1'

            version.bump :patch

            expect(version.to_s).to eq '1.2.4'
        end
    end

    describe '#bump :minor' do
        it 'bumps patch level' do
            version = Bump::VersionNumber.new 1, 2, 3

            version.bump :minor

            expect(version.to_s).to eq '1.3.0'
        end

        it 'remove suffix if it is set' do
            version = Bump::VersionNumber.new 1, 2, 3, 'rc1'

            version.bump :minor

            expect(version.to_s).to eq '1.3.0'
        end
    end

    describe '#bump :major' do
        it 'bumps patch level' do
            version = Bump::VersionNumber.new 1, 2, 3

            version.bump :major

            expect(version.to_s).to eq '2.0.0'
        end

        it 'remove suffix if it is set' do
            version = Bump::VersionNumber.new 1, 2, 3, 'rc1'

            version.bump :major

            expect(version.to_s).to eq '2.0.0'
        end
    end

    describe '#setPreid' do
        it 'sets the preid' do
            version = Bump::VersionNumber.new 1, 2, 3

            version.setPreid 'rc1'

            expect(version.to_s).to eq '1.2.3-rc1'
        end

        it 'rewrite the preid if it is already set' do
            version = Bump::VersionNumber.new 1, 2, 3, 'rc1'

            version.setPreid 'rc2'

            expect(version.to_s).to eq '1.2.3-rc2'
        end
    end
end
