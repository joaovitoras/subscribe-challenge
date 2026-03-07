require 'domain/services/tax_strategies/base_tax'

module Domain
  module Services
    module TaxStrategies
      class BasicSalesTax < BaseTax
        EXEMPT_PRODUCT_CATEGORIES = ['book', 'food', 'medical'].freeze
        BASIC_TAX_RATE = 0.10

        protected

        def tax_rate
          BASIC_TAX_RATE
        end

        def exempt?
          EXEMPT_PRODUCT_CATEGORIES.include?(@product.category)
        end
      end
    end
  end
end
