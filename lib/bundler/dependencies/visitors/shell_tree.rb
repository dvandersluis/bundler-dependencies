module Bundler
  module Dependencies
    module Visitors
      class ShellTree
        def walk(graph, shell)
          Visitor.walk(graph) do |gem, depth|
            if depth > 0
              print '  ' * depth
              print '- '
            end

            shell.say(gem.name, (:bold if depth == 0))
          end

          nil
        end
      end
    end
  end
end
