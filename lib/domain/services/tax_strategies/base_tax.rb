module Domain
  module Services
    module TaxStrategies
      class BaseTax
        ROUND_STEP = 0.05

        def initialize(product)
          @product = product
        end

        def calculate_tax
          return 0.0 if exempt?

          round_tax(@product.price * tax_rate)
        end

        protected

        def tax_rate
          raise NotImplementedError, 'Subclasses must implement tax_rate'
        end

        def exempt?
          raise NotImplementedError, 'Subclasses must implement exempt?'
        end

        private

        def round_tax(amount)
          (amount / ROUND_STEP).ceil * ROUND_STEP
        end
      end
    end
  end
end
