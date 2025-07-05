require 'domain/services/tax_strategies/base_tax'

module Domain
  module Services
    module TaxStrategies
      class BasicTax < BaseTax
        EXEMPT_PRODUCT_CATEGORIES = ['book', 'food', 'medical'].freeze

        def rate
          0.1
        end

        def exempt?
          EXEMPT_PRODUCT_CATEGORIES.include?(product.category)
        end
      end
    end
  end
end
