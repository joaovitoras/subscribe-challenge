require 'domain/services/tax_calculator'
require 'domain/services/product/category_classifier'

module Domain
  module Entities
    class Product
      attr_reader :quantity, :name, :price, :category

      def initialize(quantity:, name:, price:)
        @quantity = quantity
        @name = name
        @price = price
        @category = Domain::Services::Product::CategoryClassifier.new(name).name
      end

      def imported?
        name.downcase.include?('imported')
      end
    end
  end
end
