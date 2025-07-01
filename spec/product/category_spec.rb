require 'product/category'

RSpec.describe Product::Category do
  let(:category) { described_class.new(product_name) }

  describe '#initialize' do
    let(:product_name) { 'book' }

    it { expect { category }.not_to raise_error }

    describe 'when product name is nil' do
      let(:product_name) { nil }

      it { expect { category }.to raise_error(ArgumentError, 'Product name cannot be blank') }
    end
  end

  describe '#name' do
    context 'with book product' do
      let(:product_name) { 'book' }

      it 'returns book category' do
        expect(category.name).to eq('book')
      end
    end

    context 'with book in product name' do
      let(:product_name) { 'imported book' }

      it 'returns book category' do
        expect(category.name).to eq('book')
      end
    end

    context 'with book in different case' do
      let(:product_name) { 'BOOK of stories' }

      it 'returns book category' do
        expect(category.name).to eq('book')
      end
    end

    context 'with food in product name' do
      let(:product_name) { 'box of chocolates' }

      it 'returns food category' do
        expect(category.name).to eq('food')
      end
    end

    context 'with medical in product name' do
      let(:product_name) { 'headache pills' }

      it 'returns medical category' do
        expect(category.name).to eq('medical')
      end
    end

    context 'with general product' do
      let(:product_name) { 'perfume' }

      it 'returns general category' do
        expect(category.name).to eq('general')
      end
    end

    context 'with multiple matching keywords' do
      let(:product_name) { 'chocolate book' }

      it 'returns the first matching category' do
        expect(category.name).to eq('book')
      end
    end

    context 'with product containing partial matches' do
      let(:product_name) { 'booking chocolate pills' }

      it 'returns the first matching category' do
        expect(category.name).to eq('book')
      end
    end
  end
end
