require 'domain/services/tax_strategies/base_tax'

module Domain
  module Services
    module TaxStrategies
      class ImportDutyTax < BaseTax
        def rate
          0.05
        end

        def exempt?
          !product.imported?
        end
      end
    end
  end
end
