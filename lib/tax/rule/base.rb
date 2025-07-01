module Tax
  module Rule
    class Base
      attr_reader :item

      def initialize(item)
        @item = item
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
