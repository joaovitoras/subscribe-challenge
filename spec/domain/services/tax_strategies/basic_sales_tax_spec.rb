require 'domain/services/tax_strategies/basic_sales_tax'
require 'domain/entities/product'

RSpec.describe Domain::Services::TaxStrategies::BasicSalesTax do
  let(:product) { instance_double(Domain::Entities::Product) }
  let(:rule) { described_class.new(product) }

  describe '#tax_rate' do
    it 'returns 0.1 (10%)' do
      expect(rule.send(:tax_rate)).to eq(0.1)
    end
  end

  describe '#exempt?' do
    context 'with exempt category' do
      before do
        allow(product).to receive(:category).and_return('book')
      end

      it 'returns true' do
        expect(rule.send(:exempt?)).to be true
      end
    end

    context 'with non-exempt category' do
      before do
        allow(product).to receive(:category).and_return('general')
      end

      it 'returns false' do
        expect(rule.send(:exempt?)).to be false
      end
    end
  end
end
