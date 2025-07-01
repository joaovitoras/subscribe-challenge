require 'product'

RSpec.describe Product do
  let(:quantity) { 2 }
  let(:name) { 'book' }
  let(:price) { 12.49 }
  let(:product) { described_class.new(quantity:, name:, price:) }

  describe '#initialize' do
    it 'sets the quantity, name, and price' do
      expect(product.quantity).to eq(quantity)
      expect(product.name).to eq(name)
      expect(product.price).to eq(price)
    end
  end

  describe '#total_price_with_tax' do
    context 'with no tax' do
      let(:name) { 'book' }

      it 'returns price * quantity when no tax applies' do
        expect(product.total_price_with_tax).to eq(24.98)
      end
    end

    context 'with basic tax' do
      let(:name) { 'perfume' }

      it 'returns (price + tax) * quantity' do
        # general products are subject to 10% basic tax
        # tax = 12.49 * 0.1 = 1.249, rounded to 1.25
        # total per item = 12.49 + 1.25 = 13.74
        # total for 2 items = 13.74 * 2 = 27.48
        expect(product.total_price_with_tax).to eq(27.48)
      end
    end

    context 'with import duty' do
      let(:name) { 'imported book' }

      it 'applies import duty tax' do
        # imported books are exempt from basic tax, but subject to 5% import duty
        # tax = 12.49 * 0.05 = 0.6245, rounded to 0.65
        # total per item = 12.49 + 0.65 = 13.14
        # total for 2 items = 13.14 * 2 = 26.28
        expect(product.total_price_with_tax).to eq(26.28)
      end
    end

    context 'with both basic tax and import duty' do
      let(:name) { 'imported perfume' }

      it 'applies both taxes' do
        # general imported products are subject to both 10% basic tax and 5% import duty = 15% total
        # tax = 12.49 * 0.15 = 1.8735, rounded to 1.90
        # total per item = 12.49 + 1.90 = 14.39
        # total for 2 items = 14.39 * 2 = 28.78
        expect(product.total_price_with_tax).to eq(28.78)
      end
    end
  end

  describe '#tax' do
    context 'with exempt product' do
      let(:name) { 'chocolate' }

      it 'returns 0 tax' do
        expect(product.tax).to eq(0.0)
      end
    end

    context 'with non-exempt product' do
      let(:name) { 'perfume' }

      it 'returns calculated tax amount' do
        # perfume is subject to 10% basic tax
        # tax = 12.49 * 0.1 = 1.249, rounded to 1.25
        expect(product.tax).to eq(1.25)
      end
    end

    context 'with imported non-exempt product' do
      let(:name) { 'imported perfume' }

      it 'returns tax with both basic and import duty' do
        # imported perfume: 10% basic + 5% import = 15% total
        # tax = 12.49 * 0.15 = 1.8735, rounded to 1.90
        expect(product.tax).to be_within(0.01).of(1.90)
      end
    end
  end

  describe '#sale_tax' do
    let(:name) { 'perfume' }

    it 'returns tax multiplied by quantity' do
      # tax per item = 1.25, quantity = 2
      expect(product.sale_tax).to eq(2.50)
    end
  end

  describe '#category' do
    context 'with book' do
      let(:name) { 'book' }

      it 'returns book category' do
        expect(product.category).to eq('book')
      end
    end

    context 'with chocolate' do
      let(:name) { 'chocolate' }

      it 'returns food category' do
        expect(product.category).to eq('food')
      end
    end

    context 'with pill' do
      let(:name) { 'pill' }

      it 'returns medical category' do
        expect(product.category).to eq('medical')
      end
    end

    context 'with other product' do
      let(:name) { 'perfume' }

      it 'returns general category' do
        expect(product.category).to eq('general')
      end
    end
  end

  describe '#imported?' do
    context 'with imported product' do
      let(:name) { 'imported chocolate' }

      it 'returns true' do
        expect(product.imported?).to be true
      end
    end

    context 'with imported in different case' do
      let(:name) { 'IMPORTED chocolate' }

      it 'returns true' do
        expect(product.imported?).to be true
      end
    end

    context 'with non-imported product' do
      let(:name) { 'chocolate' }

      it 'returns false' do
        expect(product.imported?).to be false
      end
    end
  end
end
