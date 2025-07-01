require_relative 'receipt'

class ShoppingBasket
  def initialize(products)
    @products = products
  end

  def print_receipt
    Receipt.new(@products).print
  end
end
