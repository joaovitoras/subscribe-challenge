require 'domain/services/tax_strategies/base_tax'

module Domain
  module Services
    module TaxStrategies
      class ImportDutyTax < BaseTax
        IMPORT_DUTY_RATE = 0.05

        protected

        def tax_rate
          IMPORT_DUTY_RATE
        end

        def exempt?
          !@product.imported?
        end
      end
    end
  end
end
