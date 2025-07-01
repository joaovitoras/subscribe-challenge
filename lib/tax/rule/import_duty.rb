require 'tax/rule/base'

module Tax
  module Rule
    class ImportDuty < Base
      def rate
        0.05
      end

      def exempt?
        !item.imported?
      end
    end
  end
end
