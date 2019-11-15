require 'spec_helper'

RSpec.describe Bundler::Dependencies::Spec do
  subject(:spec) { described_class.new(:rubocop) }

  describe '#flatten' do
    it 'returns each dependency once' do
      gems = %w(jaro_winkler parallel parser ast rainbow ruby-progressbar unicode-display_width)
      expect(spec.flatten).to eq(gems.map { |gem| described_class.new(gem) })
    end
  end

  describe '#dependency_count' do
    it 'counts nested dependencies' do
      expect(spec.dependency_count).to eq(7)
    end
  end
end
