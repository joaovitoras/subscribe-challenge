module Infrastructure
  class FileHandler
    def self.pattern_to_file_path(file_patterns, &block)
      Dir.glob(file_patterns).each do |file_path|
        block.call(file_path)
      end
    end
  end
end
