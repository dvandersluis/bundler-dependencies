require 'spec_helper'

RSpec.describe Bundler::Dependencies::Visitor do
  subject { described_class }

  describe '#walk' do
    it 'traverses the tree' do
      arr = []
      subject.walk(graph) { |gem, depth| arr << [gem.name, depth] }

      expect(arr).to eq([
        [:pry, 0], [:coderay, 1], [:method_source, 1], [:rake, 0], [:rspec, 0], [:"rspec-core", 1], [:"rspec-support", 2],
        [:"rspec-expectations", 1], [:"diff-lcs", 2], [:"rspec-support", 2], [:"rspec-mocks", 1], [:"diff-lcs", 2],
        [:"rspec-support", 2], [:rubocop, 0], [:jaro_winkler, 1], [:parallel, 1], [:parser, 1], [:ast, 2], [:rainbow, 1],
        [:"ruby-progressbar", 1], [:"unicode-display_width", 1]
      ])
    end
  end
end
