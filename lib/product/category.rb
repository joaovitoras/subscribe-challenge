class Product
  class Category
    CATEGORIES = {
      'book' => ['book'],
      'food' => ['chocolate'],
      'medical' => ['pill']
    }.freeze

    def initialize(product_name)
      @product_name = product_name
    end

    def name
      CATEGORIES.find do |_, keywords|
        keywords.any? { |keyword| @product_name.downcase.include?(keyword) }
      end&.first || 'general'
    end
  end
end
