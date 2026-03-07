require 'domain/services/tax_strategies/base_tax'
require 'domain/entities/product'

RSpec.describe Domain::Services::TaxStrategies::BaseTax do
  let(:product) { instance_double(Domain::Entities::Product) }
  let(:rule) { described_class.new(product) }

  describe '#tax_rate' do
    it 'raises NotImplementedError' do
      expect { rule.send(:tax_rate) }.to raise_error(NotImplementedError, 'Subclasses must implement tax_rate')
    end
  end

  describe '#exempt?' do
    it 'raises NotImplementedError' do
      expect { rule.send(:exempt?) }.to raise_error(NotImplementedError, 'Subclasses must implement exempt?')
    end
  end
end
