require 'tax/rule/import_duty'
require 'product'

RSpec.describe Tax::Rule::ImportDuty do
  let(:product) { instance_double(Product) }
  let(:rule) { described_class.new(product) }

  describe '#rate' do
    it 'returns 0.05 (5%)' do
      expect(rule.rate).to eq(0.05)
    end

    it 'always returns the same rate regardless of product' do
      different_product = instance_double(Product)
      different_rule = described_class.new(different_product)
      expect(different_rule.rate).to eq(0.05)
    end
  end

  describe '#exempt?' do
    before do
      allow(product).to receive(:imported?).and_return(imported)
    end

    context 'with imported product' do
      let(:imported) { true }

      it 'returns false' do
        expect(rule.exempt?).to be false
      end
    end

    context 'with non-imported product' do
      let(:imported) { false }

      it 'returns true' do
        expect(rule.exempt?).to be true
      end
    end
  end
end
