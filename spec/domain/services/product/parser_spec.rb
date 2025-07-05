require 'domain/services/product/parser'

RSpec.describe Domain::Services::Product::Parser do
  let(:parser) { described_class.new }

  describe '#parse' do
    subject(:parse_result) { parser.parse(text) }

    context 'with valid format' do
      let(:text) { '1 book at 12.49' }

      it 'returns a Product instance with correct attributes' do
        expect(parse_result).to be_a(Domain::Entities::Product)
        expect(parse_result.quantity).to eq(1)
        expect(parse_result.name).to eq('book')
        expect(parse_result.price).to eq(12.49)
      end
    end

    context 'with multi-digit quantity' do
      let(:text) { '10 chocolate bar at 0.85' }

      it 'parses attributes correctly' do
        expect(parse_result.quantity).to eq(10)
        expect(parse_result.name).to eq('chocolate bar')
        expect(parse_result.price).to eq(0.85)
      end
    end

    context 'with complex product name' do
      let(:text) { '1 imported bottle of perfume at 47.50' }

      it 'parses attributes correctly' do
        expect(parse_result.name).to eq('imported bottle of perfume')
        expect(parse_result.quantity).to eq(1)
        expect(parse_result.price).to eq(47.50)
      end
    end

    context 'with name containing extra spaces' do
      let(:text) { '1  book  with  spaces  at 12.49' }

      it 'strips extra spaces and parses attributes correctly' do
        expect(parse_result.name).to eq('book  with  spaces')
        expect(parse_result.quantity).to eq(1)
        expect(parse_result.price).to eq(12.49)
      end
    end

    context 'with integer price' do
      let(:text) { '1 book at 15' }

      it 'parses integer price as float' do
        expect(parse_result.price).to eq(15.0)
      end
    end

    context 'with invalid format - missing quantity' do
      let(:text) { 'book at 12.49' }

      it 'raises InvalidFormatError' do
        expect { parse_result }
          .to raise_error(
            Domain::Services::Product::Parser::InvalidFormatError,
            'Invalid format: book at 12.49'
          )
      end
    end

    context 'with invalid format - missing "at"' do
      let(:text) { '1 book 12.49' }

      it 'raises InvalidFormatError' do
        expect { parse_result }
          .to raise_error(
            Domain::Services::Product::Parser::InvalidFormatError,
            'Invalid format: 1 book 12.49'
          )
      end
    end

    context 'with invalid format - missing price' do
      let(:text) { '1 book at' }

      it 'raises InvalidFormatError' do
        expect { parse_result }
          .to raise_error(
            Domain::Services::Product::Parser::InvalidFormatError,
            'Invalid format: 1 book at'
          )
      end
    end

    context 'with invalid format - empty string' do
      let(:text) { '' }

      it 'raises InvalidFormatError' do
        expect { parse_result }.to raise_error(
          Domain::Services::Product::Parser::InvalidFormatError,
          'Invalid format: '
        )
      end
    end

    context 'with invalid format - non-numeric quantity' do
      let(:text) { 'one book at 12.49' }

      it 'raises InvalidFormatError' do
        expect { parse_result }
          .to raise_error(
            Domain::Services::Product::Parser::InvalidFormatError,
            'Invalid format: one book at 12.49'
          )
      end
    end

    context 'with invalid format - non-numeric price' do
      let(:text) { '1 book at twelve' }

      it 'raises InvalidFormatError' do
        expect { parse_result }
          .to raise_error(
            Domain::Services::Product::Parser::InvalidFormatError,
            'Invalid format: 1 book at twelve'
          )
      end
    end
  end
end
