require 'product/parser'

RSpec.describe Product::Parser do
  let(:parser) { described_class.new(text) }

  describe '#product' do
    context 'with valid format' do
      let(:text) { '1 book at 12.49' }

      it 'returns a Product instance with correct attributes' do
        expect(parser.product).to be_a(Product)
        expect(parser.product.quantity).to eq(1)
        expect(parser.product.name).to eq('book')
        expect(parser.product.price).to eq(12.49)
      end
    end

    context 'with multi-digit quantity' do
      let(:text) { '10 chocolate bar at 0.85' }

      it 'parses attributes correctly' do
        expect(parser.product.quantity).to eq(10)
        expect(parser.product.name).to eq('chocolate bar')
        expect(parser.product.price).to eq(0.85)
      end
    end

    context 'with complex product name' do
      let(:text) { '1 imported bottle of perfume at 47.50' }

      it 'parses attributes correctly' do
        expect(parser.product.name).to eq('imported bottle of perfume')
        expect(parser.product.quantity).to eq(1)
        expect(parser.product.price).to eq(47.50)
      end
    end

    context 'with name containing extra spaces' do
      let(:text) { '1  book  with  spaces  at 12.49' }

      it 'strips extra spaces and parses attributes correctly' do
        expect(parser.product.name).to eq('book  with  spaces')
        expect(parser.product.quantity).to eq(1)
        expect(parser.product.price).to eq(12.49)
      end
    end

    context 'with integer price' do
      let(:text) { '1 book at 15' }

      it 'parses integer price as float' do
        expect(parser.product.price).to eq(15.0)
      end
    end

    context 'with invalid format - missing quantity' do
      let(:text) { 'book at 12.49' }

      it 'raises InvalidFormatError' do
        expect { parser.product }.to raise_error(Product::Parser::InvalidFormatError, 'Invalid format')
      end
    end

    context 'with invalid format - missing "at"' do
      let(:text) { '1 book 12.49' }

      it 'raises InvalidFormatError' do
        expect { parser.product }.to raise_error(Product::Parser::InvalidFormatError, 'Invalid format')
      end
    end

    context 'with invalid format - missing price' do
      let(:text) { '1 book at' }

      it 'raises InvalidFormatError' do
        expect { parser.product }.to raise_error(Product::Parser::InvalidFormatError, 'Invalid format')
      end
    end

    context 'with invalid format - empty string' do
      let(:text) { '' }

      it 'raises InvalidFormatError' do
        expect { parser.product }.to raise_error(Product::Parser::InvalidFormatError, 'Invalid format')
      end
    end

    context 'with invalid format - non-numeric quantity' do
      let(:text) { 'one book at 12.49' }

      it 'raises InvalidFormatError' do
        expect { parser.product }.to raise_error(Product::Parser::InvalidFormatError, 'Invalid format')
      end
    end

    context 'with invalid format - non-numeric price' do
      let(:text) { '1 book at twelve' }

      it 'raises InvalidFormatError' do
        expect { parser.product }.to raise_error(Product::Parser::InvalidFormatError, 'Invalid format')
      end
    end
  end
end
