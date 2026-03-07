require 'domain/entities/shopping_basket'
require 'domain/entities/product'

RSpec.describe Domain::Entities::ShoppingBasket do
  let(:products) { [first_product] }
  let(:first_product) { instance_double(Domain::Entities::Product) }
  let(:second_product) { instance_double(Domain::Entities::Product) }
  let(:shopping_basket) { described_class.new([first_product]) }

  describe '#add_products' do
    it 'adds products to the basket' do
      expect { shopping_basket.add_products([second_product]) }
        .to change(shopping_basket, :products)
        .from([first_product])
        .to contain_exactly(first_product, second_product)
    end
  end
end
