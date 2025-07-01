require 'shopping_basket'
require 'product'

RSpec.describe ShoppingBasket do
  let(:products) { [first_product, second_product] }
  let(:first_product) { instance_double(Product) }
  let(:second_product) { instance_double(Product) }
  let(:shopping_basket) { described_class.new(products) }

  describe '#print_receipt' do
    let(:receipt_double) { instance_double(Receipt) }

    before do
      allow(Receipt).to receive(:new).with(products).and_return(receipt_double)
      allow(receipt_double).to receive(:print)
    end

    it 'creates a Receipt with the products' do
      shopping_basket.print_receipt
      expect(Receipt).to have_received(:new).with(products)
    end

    it 'calls print on the receipt' do
      shopping_basket.print_receipt
      expect(receipt_double).to have_received(:print)
    end

    it 'returns the result of receipt print' do
      allow(receipt_double).to receive(:print).and_return('receipt output')
      expect(shopping_basket.print_receipt).to eq('receipt output')
    end
  end
end
