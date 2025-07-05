require 'application/process_receipt'
require 'infrastructure/file_handler'

class TaxCalculatorApp
  MESSAGES = {
    match: '✅ Output matches expected result!',
    mismatch: '❌ Output does not match expected result!'
  }.freeze

  def initialize
    @process_receipt = Application::ProcessReceipt.new
  end

  def run(file_patterns)
    return show_usage if file_patterns.empty?

    Infrastructure::FileHandler.pattern_to_file_path(file_patterns) do |file_path|
      process_file(file_path)
    end
  end

  private

  def process_file(file_path)
    result = @process_receipt.execute(file_path)

    puts result[:filename]
    puts result[:receipt]
    puts MESSAGES[result[:validation][:status]]
  rescue StandardError => e
    puts "Error processing #{file_path}: #{e.message}\n#{e.backtrace.join("\n")}"
  ensure
    puts '-----------------------------------'
  end

  def show_usage
    puts <<~USAGE
      Usage:
      ruby main.rb test.txt [test-2.txt ...]
      ruby main.rb inputs/*
    USAGE
  end
end
