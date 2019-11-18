module Bundler
  module Dependencies
    class CLI < ::Thor
      class Graph < Command
        include CLI::WithGem

      private

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
      end
    end
  end
end
