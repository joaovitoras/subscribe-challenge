module Infrastructure
  class FileHandler
    def self.pattern_to_file_path(file_patterns, &block)
      Dir.glob(file_patterns).each do |file_path|
        block.call(file_path)
      end
    end

    def self.read_file(file_path)
      File.read(file_path)
    end

    def self.file_exists?(file_path)
      File.exist?(file_path)
    end
  end
end
