class Receipt
  def initialize(products)
    @products = products
  end

  def to_text
    to_lines.join("\n")
  end

  def to_lines # rubocop:disable Metrics/MethodLength
    lines = []
    total_sales_taxes = 0.0
    total_price = 0.0

    @products.each do |product|
      lines << product_line(product)
      total_sales_taxes += product.sale_tax
      total_price += product.total_price_with_tax
    end

    lines << format('Sales Taxes: %.2f', total_sales_taxes)
    lines << format('Total: %.2f', total_price)
    lines
  end

  private

  def product_line(product)
    format(
      '%<quantity>d %<name>s: %<price>.2f',
      quantity: product.quantity,
      name: product.name,
      price: product.total_price_with_tax
    )
  end
end
