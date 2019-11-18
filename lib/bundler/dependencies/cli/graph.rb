module Bundler
  module Dependencies
    class CLI < ::Thor
      class Graph < Command
        def initialize(gem, options)
          @gem = gem
          super(options)
        end

      private

        attr_reader :gem

        def to_s
          Visitors::ShellTree.new.walk(graph.without(*without), shell)
        end

        def graph
          gem ? Bundler::Dependencies::Graph.new(specs: [Spec.find(gem)]) : super
        end
      end
    end
  end
end
