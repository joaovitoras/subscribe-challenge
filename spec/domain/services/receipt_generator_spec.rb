require 'domain/services/receipt_generator'
require 'domain/entities/product'
require 'domain/entities/shopping_basket'
require 'domain/services/tax_calculator'

RSpec.describe Domain::Services::ReceiptGenerator do
  let(:tax_calculator) { instance_double(Domain::Services::TaxCalculator) }
  let(:receipt_generator) { described_class.new(tax_calculator: tax_calculator) }
  let(:products) { [first_product, second_product] }
  let(:first_product) { instance_double(Domain::Entities::Product) }
  let(:second_product) { instance_double(Domain::Entities::Product) }
  let(:basket) { instance_double(Domain::Entities::ShoppingBasket, products: products) }

  describe '#generate_receipt' do
    before do
      allow(first_product).to receive_messages(
        quantity: 1, name: 'book', price: 12.49
      )
      allow(second_product).to receive_messages(
        quantity: 1, name: 'music CD', price: 14.99
      )
      allow(tax_calculator).to receive(:calculate_total_tax_for_basket).with(basket).and_return(1.50)
      allow(tax_calculator).to receive(:calculate_tax_for_product).with(first_product).and_return(0.00)
      allow(tax_calculator).to receive(:calculate_tax_for_product).with(second_product).and_return(1.50)
    end

    it 'prints complete receipt' do # rubocop:todo RSpec/ExampleLength
      expect(receipt_generator.generate_receipt(basket)).to eq(
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
        allow(first_product).to receive_messages(quantity: 2, price: 12.49)
        allow(tax_calculator).to receive(:calculate_tax_for_product).with(first_product).and_return(0.00)
        allow(tax_calculator).to receive(:calculate_total_tax_for_basket).with(basket).and_return(1.50)
      end

      it 'prints complete receipt' do # rubocop:todo RSpec/ExampleLength
        expect(receipt_generator.generate_receipt(basket)).to eq(
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

      before do
        allow(tax_calculator).to receive(:calculate_total_tax_for_basket).with(basket).and_return(0.00)
      end

      it 'prints zero totals' do # rubocop:disable RSpec/ExampleLength
        expect(receipt_generator.generate_receipt(basket)).to eq(
          <<~OUTPUT.strip
            Sales Taxes: 0.00
            Total: 0.00
          OUTPUT
        )
      end
    end

    context 'with single product' do
      let(:products) { [first_product] }

      before do
        allow(tax_calculator).to receive(:calculate_total_tax_for_basket).with(basket).and_return(0.00)
        allow(tax_calculator).to receive(:calculate_tax_for_product).with(first_product).and_return(0.00)
      end

      it 'prints single product receipt' do # rubocop:todo RSpec/ExampleLength
        expect(receipt_generator.generate_receipt(basket)).to eq(
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
