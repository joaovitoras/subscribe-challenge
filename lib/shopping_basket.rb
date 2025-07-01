require_relative 'receipt'

class ShoppingBasket
  attr_reader :products

  def initialize
    @products = []
  end

  def add_product(product)
    @products << product
  end
end
