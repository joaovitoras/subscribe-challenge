require 'tax/calculator'
require 'product/category'

class Product
  attr_reader :quantity, :name, :price

  def initialize(quantity:, name:, price:)
    @quantity = quantity
    @name = name
    @price = price
    @tax_calculator = Tax::Calculator.new(self)
    @category = Category.new(name)
  end

  def total_price_with_tax
    (price + tax) * quantity
  end

  def tax
    @tax_calculator.tax
  end

  def sale_tax
    tax * quantity
  end

  def category
    @category.name
  end

  def imported?
    name.downcase.include?('imported')
  end
end
