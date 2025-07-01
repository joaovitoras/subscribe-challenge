require 'tax/rule/base'

module Tax
  module Rule
    class Basic < Base
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
