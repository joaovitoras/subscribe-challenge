module Domain
  module Services
    module Product
      class CategoryClassifier
        CATEGORIES = {
          'book' => ['book'],
          'food' => ['chocolate'],
          'medical' => ['pill']
        }.freeze

        def initialize(name)
          @name = name
          raise ArgumentError, 'Name cannot be blank' if @name.nil? || @name.strip.empty?
        end

        def name
          CATEGORIES.find do |_, keywords|
            keywords.any? { |keyword| @name.downcase.include?(keyword) }
          end&.first || 'general'
        end
      end
    end
  end
end
