require 'spec_helper'

RSpec.describe Bundler::Dependencies::Scanner do
  subject { described_class.new(File.expand_path('../../support/Gemfile.lock', __dir__)) }

  describe '#gem_count' do
    it 'returns the number of gems directly depended on' do
      expect(subject.gem_count).to eq(4)
    end
  end

  describe '#spec_count' do
    it 'returns the total number of gems loaded' do
      expect(subject.spec_count).to eq(20)
    end
  end

  describe '#counts' do
    it 'returns how many gems each gem depends on' do
      expect(subject.counts).to eq(rubocop: 7, rspec: 5, pry: 2, rake: 0)
    end

    context 'when given a minimum' do
      it 'only returns gems with at least that many dependencies' do
        expect(subject.counts(min: 5)).to eq(rubocop: 7, rspec: 5)
      end
    end
  end
end
