describe Bump::Command do

    describe '#exec' do

        it 'prints and executes the command' do

            logger = Bump::Logger.new

            comm = Bump::Command.new logger

            expect(logger).to receive(:green).with('+echo 1').once
            allow(logger).to receive(:green) { 'greened +echo 1' }
            expect(logger).to receive(:log).with('greened +echo 1').once
            expect(logger).to receive(:log).with("1\n", nil).once

            comm.exec 'echo 1'

        end

    end

end
