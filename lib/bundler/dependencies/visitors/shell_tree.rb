# frozen_string_literal: true

module Bundler
  module Dependencies
    module Visitors
      class ShellTree
        def walk(graph, shell = nil)
          Visitor.walk(graph) do |gem, depth|
            if depth > 0
              print '  ' * depth
              print '- '
            end

            say(shell, gem.name, (:bold if depth == 0))
          end

          nil
        end

        private

        def say(shell, message, opts)
          if shell
            shell.say(message, opts)
          else
            puts message
          end
        end
      end
    end
  end
end
