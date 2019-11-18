module Bundler
  module Dependencies
    module Visitors
      class Paths
        def walk(graph, name, acc = [], key = [])
          graph.each do |gem|
            next unless gem.include_dependency?(name)

            new_key = key.dup.push(gem.name)
            walk(gem.dependencies, name, acc, new_key)
            acc << (new_key << name) if gem.dependencies.include?(name)
          end

          acc
        end
      end
    end
  end
end
