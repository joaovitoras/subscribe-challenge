if ARGV.empty?
  puts <<~USAGE
    Usage:
    ruby main.rb input.txt [input-2.txt ...]
    ruby main.rb inputs/*
  USAGE

  exit
end

$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require 'shopping_basket'
require 'product/parser'

Dir.glob(ARGV).each do |filename|
  products = []

  File.foreach(filename) do |text|
    parser = Product::Parser.new(text)
    products << parser.product
  end

  shopping_basket = ShoppingBasket.new(products)

  puts "Receipt for #{filename}:"
  shopping_basket.print_receipt
  puts '-----------------------------------'
end
