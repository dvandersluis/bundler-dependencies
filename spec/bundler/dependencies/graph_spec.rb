require 'spec_helper'

RSpec.describe Bundler::Dependencies::Graph do
  let(:baz) { Bundler::Dependencies::Spec.new(:baz, [:bar]) }
  let(:quux) { Bundler::Dependencies::Spec.new(:quux, [:bar]) }

  let(:graph) do
    described_class.new(specs: [baz, quux])
  end

  before do
    Bundler::Dependencies::Spec.new(:foo)
    Bundler::Dependencies::Spec.new(:bar, [:foo])
  end

  RSpec::Matchers.define(:include_dependency) do |expected|
    match do |actual|
      actual.include_dependency?(expected)
    end
  end

  describe '#empty?' do
    it 'returns true for a graph with no specs' do
      expect(described_class.new).to be_empty
    end

    it 'returns true if specs is an array of nil' do
      expect(described_class.new(specs: [nil])).to be_empty
    end

    it 'returns false for a graph with specs' do
      expect(graph).to_not be_empty
    end
  end

  describe '#delete' do
    it 'removes a spec from the graph' do
      graph.delete(:quux)
      expect(graph).to_not include(:quux)
    end

    it 'removes multiple specs' do
      graph.delete(:baz, :quux)
      expect(graph).to be_empty
    end
  end

  describe '#without' do
    it 'does not modify the original graph' do
      graph.without(:baz, :quux)
      expect(graph).to_not be_empty
    end

    it 'removes a spec from the graph' do
      expect(graph.without(:quux)).to_not include(:quux)
    end

    it 'removes multiple gems' do
      expect(graph.without(:baz, :quux)).to be_empty
    end

    it 'removes dependencies' do
      expect(graph.without(:bar)).to_not include_dependency(:bar)
    end

    it 'removes dependencies of dependencies' do
      # foo is only depended on by bar
      expect(graph.without(:bar)).to_not include_dependency(:foo)
    end
  end

  describe '#include?' do
    it 'returns true when the gem is a direct dependency' do
      expect(graph).to include(:baz)
    end

    it 'returns false when the gem is a child dependency' do
      expect(graph).to_not include(:bar)
    end

    it 'returns false when the gem is not in the graph' do
      expect(graph).to_not include(:test)
    end
  end

  describe '#include_dependency?' do
    it 'returns true when the gem is a direct dependency' do
      expect(graph).to include_dependency(:baz)
    end

    it 'returns true when the gem is a child dependency' do
      expect(graph).to include_dependency(:bar)
    end

    it 'returns false when the gem is not in the graph' do
      expect(graph).to_not include_dependency(:test)
    end
  end

  describe '#find' do
    it 'returns a spec if it is in the graph' do
      expect(graph.find(:bar)).to eq(Bundler::Dependencies::Spec.new(:bar))
    end

    it 'does not return a spec if it is in the graph' do
      expect(graph.find(:monkey)).to be_nil
    end
  end
end
