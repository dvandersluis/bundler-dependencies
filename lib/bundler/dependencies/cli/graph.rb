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
          if gems.empty?
            error("#{gem} is not present in your bundle.")
            exit(1)
          end

          Visitors::ShellTree.new.walk(gems, shell)
        end

        def graph
          gem ? Bundler::Dependencies::Graph.new(specs: [super.find(gem)]) : super
        end

        def gems
          @gems ||= graph.without(*without)
        end
      end
    end
  end
end
