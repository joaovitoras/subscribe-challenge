require 'receipt'
require 'product'

RSpec.describe Receipt do
  let(:products) { [first_product, second_product] }
  let(:first_product) { instance_double(Product) }
  let(:second_product) { instance_double(Product) }
  let(:receipt) { described_class.new(products) }

  describe '#print' do
    before do
      allow(first_product).to receive_messages(
        quantity: 1, name: 'book', total_price_with_tax: 12.49, sale_tax: 0.00
      )
      allow(second_product).to receive_messages(
        quantity: 1, name: 'music CD', total_price_with_tax: 16.49, sale_tax: 1.50
      )
    end

    it 'prints complete receipt' do # rubocop:todo RSpec/ExampleLength
      expect(receipt.to_text).to eq(
        <<~OUTPUT.strip
          1 book: 12.49
          1 music CD: 16.49
          Sales Taxes: 1.50
          Total: 28.98
        OUTPUT
      )
    end

    context 'with multiple quantities' do
      before do
        allow(first_product).to receive_messages(quantity: 2, total_price_with_tax: 24.98, sale_tax: 0.00)
      end

      it 'prints complete receipt' do # rubocop:todo RSpec/ExampleLength
        expect(receipt.to_text).to eq(
          <<~OUTPUT.strip
            2 book: 24.98
            1 music CD: 16.49
            Sales Taxes: 1.50
            Total: 41.47
          OUTPUT
        )
      end
    end

    context 'with no products' do
      let(:products) { [] }

      it 'prints zero totals' do # rubocop:disable RSpec/ExampleLength
        expect(receipt.to_text).to eq(
          <<~OUTPUT.strip
            Sales Taxes: 0.00
            Total: 0.00
          OUTPUT
        )
      end
    end

    context 'with single product' do
      let(:products) { [first_product] }

      it 'prints single product receipt' do # rubocop:todo RSpec/ExampleLength
        expect(receipt.to_text).to eq(
          <<~OUTPUT.strip
            1 book: 12.49
            Sales Taxes: 0.00
            Total: 12.49
          OUTPUT
        )
      end
    end
  end
end
