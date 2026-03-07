module Domain
  module Services
    class ReceiptGenerator
      def initialize(tax_calculator:)
        @tax_calculator = tax_calculator
      end

      def to_text
        to_lines.join("\n")
      end

      def generate_receipt(basket)
        lines = []
        total_price = 0.0
        total_taxes = @tax_calculator.calculate_total_tax_for_basket(basket)

        basket.products.each do |product|
          product_total = product_total(product)
          lines << format_product_line(product, product_total)
          total_price += product_total
        end

        lines << format('Sales Taxes: %.2f', total_taxes)
        lines << format('Total: %.2f', total_price)
        lines.join("\n")
      end

      private

      def format_product_line(product, total_price)
        format(
          '%<quantity>d %<name>s: %<price>.2f',
          quantity: product.quantity,
          name: product.name,
          price: total_price
        )
      end

      def product_total(product)
        product_tax = @tax_calculator.calculate_tax_for_product(product)
        (product.price + product_tax) * product.quantity
      end
    end
  end
end
