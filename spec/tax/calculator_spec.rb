require 'tax/calculator'
require 'product'

RSpec.describe Tax::Calculator do
  let(:product) { instance_double(Product) }
  let(:calculator) { described_class.new(product) }

  describe '#tax' do
    before do
      allow(product).to receive_messages(price: price, category: category, imported?: imported)
    end

    context 'with exempt product' do
      let(:price) { 12.49 }
      let(:category) { 'book' }
      let(:imported) { false }

      it 'returns 0 tax' do
        expect(calculator.tax).to eq(0.0)
      end
    end

    context 'with general product' do
      let(:price) { 14.99 }
      let(:category) { 'general' }
      let(:imported) { false }

      it 'applies basic tax only' do
        # 14.99 * 0.1 = 1.499, rounded to 1.50
        expect(calculator.tax).to eq(1.50)
      end
    end

    context 'with exempt, but imported product' do
      let(:price) { 11.25 }
      let(:category) { 'food' }
      let(:imported) { true }

      it 'applies import duty only' do
        # 11.25 * 0.05 = 0.5625, rounded to 0.60
        expect(calculator.tax).to be_within(0.01).of(0.60)
      end
    end

    context 'with non-exempt, but imported product' do
      let(:price) { 47.50 }
      let(:category) { 'general' }
      let(:imported) { true }

      it 'applies both basic tax and import duty' do
        # 47.50 * 0.15 = 7.125, rounded to 7.15
        expect(calculator.tax).to eq(7.15)
      end
    end

    context 'with small tax amount' do
      let(:price) { 0.85 }
      let(:category) { 'general' }
      let(:imported) { false }

      it 'rounds up correctly' do
        # 0.85 * 0.1 = 0.085, rounded to 0.10
        expect(calculator.tax).to eq(0.10)
      end
    end

    context 'with tax amount that needs no rounding' do
      let(:price) { 1.00 }
      let(:category) { 'general' }
      let(:imported) { false }

      it 'returns exact amount' do
        # 1.00 * 0.1 = 0.10, already at 0.05 boundary
        expect(calculator.tax).to eq(0.10)
      end
    end

    context 'with price resulting in tax at exact 0.05 boundary' do
      let(:price) { 0.50 }
      let(:category) { 'general' }
      let(:imported) { false }

      it 'returns exact amount' do
        # 0.50 * 0.1 = 0.05, exactly at boundary
        expect(calculator.tax).to eq(0.05)
      end
    end
  end
end
