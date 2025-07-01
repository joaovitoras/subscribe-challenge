require 'tax/rule/base'
require 'product'

RSpec.describe Tax::Rule::Base do
  let(:product) { instance_double(Product) }
  let(:rule) { described_class.new(product) }

  describe '#initialize' do
    it 'sets the product' do
      expect(rule.product).to eq(product)
    end
  end

  describe '#exempt?' do
    it 'raises NotImplementedError' do
      expect { rule.exempt? }.to raise_error(NotImplementedError, 'exempt?')
    end
  end

  describe '#rate' do
    it 'raises NotImplementedError' do
      expect { rule.rate }.to raise_error(NotImplementedError, 'rate')
    end
  end
end
