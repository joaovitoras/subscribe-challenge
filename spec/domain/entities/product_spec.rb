require 'domain/entities/product'

RSpec.describe Domain::Entities::Product do
  let(:quantity) { 2 }
  let(:name) { 'book' }
  let(:price) { 12.49 }
  let(:product) { described_class.new(quantity:, name:, price:) }

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
      let(:name) { 'imported perfume' }

      it 'returns true' do
        expect(product.imported?).to be true
      end
    end

    context 'with imported in different case' do
      let(:name) { 'IMPORTED book' }

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
