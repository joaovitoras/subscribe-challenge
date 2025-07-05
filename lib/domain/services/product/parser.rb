require 'domain/entities/product'

module Domain
  module Services
    module Product
      class Parser
        class InvalidFormatError < StandardError; end

        PRODUCT_PATTERN = /^(?<quantity>\d+)\s(?<name>.+)\sat\s(?<price>[\d\.]+)$/

        def parse_text_input(text_content)
          text_content.split("\n").map { |line| parse(line) if line.strip != '' }.compact
        end

        def parse(text)
          match = text.match(PRODUCT_PATTERN)

          raise InvalidFormatError, "Invalid format: #{text}" unless match

          Domain::Entities::Product.new(
            quantity: match[:quantity].to_i,
            name: match[:name].strip,
            price: match[:price].to_f
          )
        end
      end
    end
  end
end
