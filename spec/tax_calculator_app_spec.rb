require 'tax_calculator_app'

RSpec.describe TaxCalculatorApp do
  let(:app) { described_class.new }
  let(:mock_process_receipt) { instance_double(Application::ProcessReceipt) }

  before do
    allow(Application::ProcessReceipt).to receive(:new).and_return(mock_process_receipt)
  end

  describe '#run' do
    let(:patterns) { ['inputs/*.txt'] }

    context 'when no file patterns are provided' do
      it 'shows usage information' do
        expect { app.run([]) }.to output(/Usage:/).to_stdout
      end
    end

    context 'when file patterns are provided' do
      let(:file_path) { 'inputs/test-1.txt' }
      let(:result) do
        {
          filename: file_path,
          receipt: "Sample receipt\nTotal: $10.00",
          validation: { status: :match }
        }
      end

      before do
        allow(Infrastructure::FileHandler)
          .to receive(:pattern_to_file_path)
          .with(patterns)
          .and_yield(file_path)
        allow(mock_process_receipt).to receive(:execute).with(file_path).and_return(result)
      end

      it 'processes each file and displays results' do
        expect { app.run(patterns) }.to output(
          <<~OUTPUT
            #{file_path}
            #{result[:receipt]}
            #{TaxCalculatorApp::MESSAGES[:match]}
            -----------------------------------
        OUTPUT
        ).to_stdout
      end

      context 'when validation fails' do
        let(:result) do
          {
            filename: file_path,
            receipt: "Sample receipt\nTotal: $10.00",
            validation: { status: :mismatch }
          }
        end

        it 'displays mismatch message' do
          expect { app.run(patterns) }.to output(
            <<~OUTPUT
              #{file_path}
              #{result[:receipt]}
              #{TaxCalculatorApp::MESSAGES[:mismatch]}
              -----------------------------------
          OUTPUT
          ).to_stdout
        end
      end

      context 'when an error occurs during processing' do
        before do
          allow(mock_process_receipt).to receive(:execute)
            .with(file_path).and_raise(StandardError, 'Test error')
        end

        it 'displays error message and continues' do
          expect { app.run(patterns) }.to output(/Error processing #{file_path}: Test error/).to_stdout
          expect { app.run(patterns) }.to output(/-----------------------------------/).to_stdout
        end
      end
    end
  end
end
