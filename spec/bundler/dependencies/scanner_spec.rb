require 'spec_helper'

RSpec.describe Bundler::Dependencies::Scanner do
  subject { described_class.new(lockfile_path) }

  describe '#gem_count' do
    it 'returns the number of gems directly depended on' do
      expect(subject.gem_count).to eq(5)
    end
  end

  describe '#spec_count' do
    it 'returns the total number of gems loaded' do
      expect(subject.spec_count).to eq(20)
    end
  end
end
