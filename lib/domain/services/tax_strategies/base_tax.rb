module Domain
  module Services
    module TaxStrategies
      class BaseTax
        attr_reader :product

        def initialize(product)
          @product = product
        end

        def exempt?
          raise NotImplementedError, 'exempt?'
        end

        def rate
          raise NotImplementedError, 'rate'
        end
      end
    end
  end
end
