$LOAD_PATH.unshift("#{Dir.pwd}/lib")

require 'tax_calculator_app'

TaxCalculatorApp.new.run(ARGV)
