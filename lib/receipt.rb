class Receipt
  def initialize(products)
    @products = products
  end

  def print
    total_sales_taxes = 0.0
    total_price = 0.0

    @products.each do |product|
      print_product(product)
      total_sales_taxes += product.sale_tax
      total_price += product.total_price_with_tax
    end

    puts format('Sales Taxes: %.2f', total_sales_taxes)
    puts format('Total: %.2f', total_price)
  end

  private

  def print_product(product)
    puts format(
      '%<quantity>d %<name>s: %<price>.2f',
      quantity: product.quantity,
      name: product.name,
      price: product.total_price_with_tax
    )
  end
end
