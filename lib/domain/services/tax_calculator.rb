require 'domain/services/tax_strategies/basic_sales_tax'
require 'domain/services/tax_strategies/import_duty_tax'

module Domain
  module Services
    class TaxCalculator
      DEFAULT_STRATEGIES = [
        TaxStrategies::BasicSalesTax,
        TaxStrategies::ImportDutyTax
      ].freeze

      def initialize(strategies: DEFAULT_STRATEGIES)
        @strategies = strategies
      end

      def calculate_tax_for_product(product)
        total_tax = 0.0

        @strategies.each do |strategy_class|
          strategy = strategy_class.new(product)
          total_tax += strategy.calculate_tax
        end

        total_tax
      end

      def calculate_total_tax_for_basket(basket)
        total_tax = 0.0

        basket.products.each do |product|
          total_tax += calculate_tax_for_product(product) * product.quantity
        end

        total_tax
      end
    end
  end
end
