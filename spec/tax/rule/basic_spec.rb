require 'tax/rule/basic'
require 'product'

RSpec.describe Tax::Rule::Basic do
  let(:product) { instance_double(Product) }
  let(:rule) { described_class.new(product) }

  describe '#rate' do
    it 'returns 0.1 (10%)' do
      expect(rule.rate).to eq(0.1)
    end
  end

  describe '#exempt?' do
    context 'with exempt category' do
      before do
        allow(product).to receive(:category).and_return('book')
      end

      it 'returns true' do
        expect(rule.exempt?).to be true
      end
    end

    context 'with non-exempt category' do
      before do
        allow(product).to receive(:category).and_return('general')
      end

      it 'returns false' do
        expect(rule.exempt?).to be false
      end
    end
  end
end
