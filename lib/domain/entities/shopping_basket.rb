module Domain
  module Entities
    class ShoppingBasket
      attr_reader :products

      def initialize(products = [])
        @products = []

        add_products(products)
      end

      def add_products(products)
        @products.concat(products)
      end
    end
  end
end
