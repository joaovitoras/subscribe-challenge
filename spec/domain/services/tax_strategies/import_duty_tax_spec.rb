require 'domain/services/tax_strategies/import_duty_tax'
require 'domain/entities/product'

RSpec.describe Domain::Services::TaxStrategies::ImportDutyTax do
  let(:product) { instance_double(Domain::Entities::Product) }
  let(:rule) { described_class.new(product) }

  describe '#tax_rate' do
    it 'returns 0.05 (5%)' do
      expect(rule.send(:tax_rate)).to eq(0.05)
    end

    it 'always returns the same rate regardless of product' do
      different_product = instance_double(Domain::Entities::Product)
      different_rule = described_class.new(different_product)
      expect(different_rule.send(:tax_rate)).to eq(0.05)
    end
  end

  describe '#exempt?' do
    before do
      allow(product).to receive(:imported?).and_return(imported)
    end

    context 'with imported product' do
      let(:imported) { true }

      it 'returns false' do
        expect(rule.send(:exempt?)).to be false
      end
    end

    context 'with non-imported product' do
      let(:imported) { false }

      it 'returns true' do
        expect(rule.send(:exempt?)).to be true
      end
    end
  end
end
