if ARGV.empty?
  puts <<~USAGE
    Usage:
    ruby main.rb test.txt [test-2.txt ...]
    ruby main.rb inputs/*
  USAGE

  exit
end

$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require 'product/parser'
require 'shopping_basket'
require 'receipt'

def each_product(filename)
  File.foreach(filename) do |text|
    parser = Product::Parser.new(text)

    yield parser.product
  end
end

Dir.glob(ARGV).each do |filename|
  shopping_basket = ShoppingBasket.new

  each_product(filename) do |product|
    shopping_basket.add_product(product)
  end

  receipt = Receipt.new(shopping_basket.products)
  puts "Receipt for #{filename}:"
  puts receipt.to_text

  output_filename = filename.sub('inputs/', 'outputs/')

  if File.exist?(output_filename)
    expected_lines = File.read(output_filename).strip
    receipt_lines = receipt.to_text

    if receipt_lines == expected_lines
      puts '✅ Output matches expected result!'
    else
      puts '❌ Output does not match expected result!'
    end
  end

  puts '-----------------------------------'
end
