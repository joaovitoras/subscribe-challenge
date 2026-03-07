require 'infrastructure/file_handler'

RSpec.describe Infrastructure::FileHandler do
  describe '.pattern_to_file_path' do
    let(:file_patterns) { ['inputs/*.txt'] }
    let(:mock_file_paths) { ['inputs/test-1.txt', 'inputs/test-2.txt'] }

    before do
      allow(Dir).to receive(:glob).with(file_patterns).and_return(mock_file_paths)
    end

    it 'yields each matching file path to the block' do
      yielded_paths = []

      described_class.pattern_to_file_path(file_patterns) do |file_path|
        yielded_paths << file_path
      end

      expect(yielded_paths).to eq(mock_file_paths)
    end

    it 'calls Dir.glob with the provided patterns' do
      described_class.pattern_to_file_path(file_patterns) { |_path| nil }
      expect(Dir).to have_received(:glob).with(file_patterns)
    end

    context 'when no files match the pattern' do
      let(:mock_file_paths) { [] }

      it 'does not yield any paths' do
        yielded_paths = []

        described_class.pattern_to_file_path(file_patterns) do |file_path|
          yielded_paths << file_path
        end

        expect(yielded_paths).to be_empty
      end
    end
  end

  describe '.read_file' do
    let(:file_path) { 'test_file.txt' }
    let(:file_content) { 'Sample file content' }

    before do
      allow(File).to receive(:read).with(file_path).and_return(file_content)
    end

    it 'reads the content of the specified file' do
      result = described_class.read_file(file_path)
      expect(File).to have_received(:read).with(file_path)
      expect(result).to eq(file_content)
    end
  end

  describe '.file_exists?' do
    subject(:file_exists?) { described_class.file_exists?(file_path) }

    let(:file_path) { 'test_file.txt' }
    let(:method_result) { true }

    before do
      allow(File).to receive(:exist?).with(file_path).and_return(method_result)
    end

    context 'when file exists' do
      it { is_expected.to be true }
    end

    context 'when file does not exist' do
      let(:method_result) { false }

      it { is_expected.to be false }
    end

    it 'calls File.exist? with the correct file path' do
      file_exists?
      expect(File).to have_received(:exist?).with(file_path)
    end
  end
end
