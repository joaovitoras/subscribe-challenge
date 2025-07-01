require 'tax/rule/basic'
require 'tax/rule/import_duty'

module Tax
  class Calculator
    TAXES = [
      Rule::Basic,
      Rule::ImportDuty
    ].freeze
    ROUND_STEP = 0.05

    def initialize(item)
      @item = item
    end

    def tax
      round_tax(@item.price * tax_rate)
    end

    private

    def tax_rate
      tax_rate = 0.0

      TAXES.each do |rule_class|
        rule = rule_class.new(@item)
        tax_rate += rule.rate unless rule.exempt?
      end

      tax_rate
    end

    def round_tax(tax)
      ((tax / ROUND_STEP).ceil * ROUND_STEP)
    end
  end
end
