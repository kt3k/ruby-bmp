describe Bump::Command do

    describe '#exec' do

        it 'prints and executes the command' do

            logger = double

            comm = Bump::Command.new logger

            expect(logger).to receive(:log).with '===> echo 1'
            expect(logger).to receive(:log).with "1\n"

            comm.exec 'echo 1'

        end

    end

end
