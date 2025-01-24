# frozen_string_literal: true

module Bundler
  module Dependencies
    class Visitor
      def self.walk(graph, depth = 0, &block)
        graph.each do |gem|
          block.call(gem, depth)
          walk(gem.dependencies, depth + 1, &block) if gem.dependencies
        end
      end
    end
  end
end
