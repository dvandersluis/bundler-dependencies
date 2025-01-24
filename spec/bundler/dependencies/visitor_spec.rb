# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bundler::Dependencies::Visitor do
  subject { described_class }

  describe '#walk' do
    let(:expected) do
      [
        [:pry, 0],
        [:coderay, 1],
        [:method_source, 1],
        [:rake, 0],
        [:rspec, 0],
        [:'rspec-core', 1],
        [:'rspec-support', 2],
        [:'rspec-expectations', 1],
        [:'diff-lcs', 2],
        [:'rspec-support', 2],
        [:'rspec-mocks', 1],
        [:'diff-lcs', 2],
        [:'rspec-support', 2],
        [:rubocop, 0],
        [:jaro_winkler, 1],
        [:parallel, 1],
        [:parser, 1],
        [:ast, 2],
        [:rainbow, 1],
        [:'ruby-progressbar', 1],
        [:'unicode-display_width', 1],
        [:'rubocop-rspec', 0],
        [:rubocop, 1],
        [:jaro_winkler, 2],
        [:parallel, 2],
        [:parser, 2],
        [:ast, 3],
        [:rainbow, 2],
        [:'ruby-progressbar', 2],
        [:'unicode-display_width', 2]
      ]
    end

    it 'traverses the tree' do
      arr = []
      subject.walk(graph) { |gem, depth| arr << [gem.name, depth] }

      expect(arr).to eq(expected)
    end
  end
end
