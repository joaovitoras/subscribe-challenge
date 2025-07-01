require 'shopping_basket'
require 'product'

RSpec.describe ShoppingBasket do
  let(:products) { [first_product, second_product] }
  let(:first_product) { instance_double(Product) }
  let(:second_product) { instance_double(Product) }
  let(:shopping_basket) { described_class.new }

  describe '#add_product' do
    it 'adds a product to the basket' do
      shopping_basket.add_product(first_product)
      expect(shopping_basket.products).to include(first_product)
    end
  end
end
