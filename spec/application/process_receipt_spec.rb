require 'application/process_receipt'

RSpec.describe Application::ProcessReceipt do
  describe '#execute' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    subject(:process_receipt) do
      described_class.new(
        file_handler: mock_file_handler,
        parser: mock_parser,
        receipt_generator: mock_receipt_generator
      ).execute(file_path)
    end

    let(:mock_file_handler) { class_double(Infrastructure::FileHandler) }
    let(:mock_parser) { instance_double(Domain::Services::Product::Parser) }
    let(:mock_receipt_generator) { instance_double(Domain::Services::ReceiptGenerator) }
    let(:file_path) { 'inputs/test-1.txt' }
    let(:file_content) { "1 imported bottle of perfume at 27.99\n2 bottle of perfume at 18.99" }
    let(:mock_products) do
      [
        instance_double(Domain::Entities::Product),
        instance_double(Domain::Entities::Product)
      ]
    end
    let(:mock_basket) { instance_double(Domain::Entities::ShoppingBasket) }
    let(:receipt_text) { "Sample receipt\nTotal: $32.19" }

    before do
      allow(mock_file_handler).to receive(:read_file).with(file_path).and_return(file_content)
      allow(mock_parser).to receive(:parse_text_input).with(file_content).and_return(mock_products)
      allow(Domain::Entities::ShoppingBasket).to receive(:new).with(mock_products).and_return(mock_basket)
      allow(mock_receipt_generator).to receive(:generate_receipt).with(mock_basket).and_return(receipt_text)
    end

    context 'when expected output file exists and matches' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:output_file_path) { 'outputs/test-1.txt' }
      let(:expected_output) { "Sample receipt\nTotal: $32.19" }

      before do
        allow(mock_file_handler).to receive(:file_exists?).with(output_file_path).and_return(true)
        allow(mock_file_handler).to receive(:read_file).with(output_file_path).and_return(expected_output)
      end

      it 'returns successful result with match status' do
        expect(process_receipt).to eq({
          filename: file_path,
          receipt: receipt_text,
          validation: { status: :match }
        })
      end

      it 'reads the input file' do
        process_receipt
        expect(mock_file_handler).to have_received(:read_file).with(file_path)
      end

      it 'parses the file content' do
        process_receipt
        expect(mock_parser).to have_received(:parse_text_input).with(file_content)
      end

      it 'creates a shopping basket with products' do
        process_receipt
        expect(Domain::Entities::ShoppingBasket).to have_received(:new).with(mock_products)
      end

      it 'generates receipt from basket' do
        process_receipt
        expect(mock_receipt_generator).to have_received(:generate_receipt).with(mock_basket)
      end
    end

    context 'when expected output file exists but does not match' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:output_file_path) { 'outputs/test-1.txt' }
      let(:expected_output) { "Different receipt\nTotal: $25.00" }

      before do
        allow(mock_file_handler).to receive(:file_exists?).with(output_file_path).and_return(true)
        allow(mock_file_handler).to receive(:read_file).with(output_file_path).and_return(expected_output)
      end

      it 'returns result with mismatch status' do
        expect(process_receipt).to eq({
          filename: file_path,
          receipt: receipt_text,
          validation: {
            status: :mismatch,
            expected: expected_output,
            actual: receipt_text
          }
        })
      end
    end

    context 'when expected output file does not exist' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:output_file_path) { 'outputs/test-1.txt' }

      before do
        allow(mock_file_handler).to receive(:file_exists?).with(output_file_path).and_return(false)
      end

      it 'returns result with no expected output status' do
        expect(process_receipt).to eq({
          filename: file_path,
          receipt: receipt_text,
          validation: { status: :no_expected_output }
        })
      end

      it 'does not attempt to read the output file' do
        process_receipt
        expect(mock_file_handler).not_to have_received(:read_file).with(output_file_path)
      end
    end

    context 'when working with different input file paths' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:file_path) { 'inputs/subfolder/test-nested.txt' }
      let(:expected_output_path) { 'outputs/subfolder/test-nested.txt' }

      before do
        allow(mock_file_handler).to receive(:read_file).with(file: file_path).and_return(file_content)
        allow(mock_file_handler).to receive(:file_exists?).with(expected_output_path).and_return(false)
      end

      it 'correctly transforms input path to output path' do
        process_receipt
        expect(mock_file_handler).to have_received(:file_exists?).with(expected_output_path)
      end
    end
  end
end
