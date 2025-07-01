require 'product'

class Product
  class Parser
    class InvalidFormatError < StandardError; end

    def initialize(text)
      @text = text
    end

    def product
      parsed = parse

      raise InvalidFormatError, 'Invalid format' unless parsed

      Product.new(
        quantity: parsed[:quantity].to_i,
        name: parsed[:name].strip,
        price: parsed[:price].to_f
      )
    end

    private

    def parse
      @text.to_s.match(/^(?<quantity>\d+)\s(?<name>.+)\sat\s(?<price>[\d\.]+)$/)
    end
  end
end
