require 'domain/value_objects/money'

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

      def total_base_price
        total = @products.sum { |product| product.total_base_price.amount }
        ValueObjects::Money.new(total)
      end

      def empty?
        @products.empty?
      end

      def size
        @products.size
      end
    end
  end
end
