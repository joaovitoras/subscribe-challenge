require 'domain/entities/shopping_basket'
require 'domain/services/product/parser'
require 'domain/services/receipt_generator'
require 'domain/services/tax_calculator'
require 'infrastructure/file_handler'

module Application
  class ProcessReceipt
    def initialize(
      file_handler: Infrastructure::FileHandler,
      parser: Domain::Services::Product::Parser.new,
      receipt_generator: Domain::Services::ReceiptGenerator.new(
        tax_calculator: Domain::Services::TaxCalculator.new
      )
    )
      @parser = parser
      @file_handler = file_handler
      @receipt_generator = receipt_generator
    end

    def execute(file_path)
      lines = @file_handler.read_file(file_path)
      products = @parser.parse_text_input(lines)
      basket = Domain::Entities::ShoppingBasket.new(products)
      receipt_text = @receipt_generator.generate_receipt(basket)
      validation_result = validate_output(receipt_text, file_path)

      {
        filename: file_path,
        receipt: receipt_text,
        validation: validation_result
      }
    end

    private

    def validate_output(receipt_text, file_path)
      output_filepath = file_path.sub('inputs/', 'outputs/')

      return { status: :no_expected_output } unless @file_handler.file_exists?(output_filepath)

      expected_output = @file_handler.read_file(output_filepath).strip

      if receipt_text == expected_output
        { status: :match }
      else
        { status: :mismatch, expected: expected_output, actual: receipt_text }
      end
    end
  end
end
