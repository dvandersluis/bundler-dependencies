module Bundler
  module Dependencies
    class Scanner
      def initialize(path = Bundler.default_lockfile)
        @lockfile = LockfileParser.new(Bundler.read_file(path))
      end

      def gem_count
        gems.count
      end

      def spec_count
        specs.count
      end

      def dependencies
        @dependencies ||= gems.each_with_object({}) do |gem, results|
          dependencies = dependencies_of(gem)
          results[gem] = dependencies
        end
      end

      def counts(min = 0)
        @counts ||= dependencies.each_with_object({}) do |(gem, dependencies), acc|
          count = dependencies.count
          next if count < min

          acc[gem] = count
        end.sort_by(&:last).reverse
      end

      def graph
        gems.each_with_object({}) do |gem, results|
          graph = graph_of(gem)
          results[gem] = graph
        end
      end

    private

      attr_reader :lockfile

      def gems
        lockfile.dependencies.keys
      end

      def specs
        lockfile.specs
      end

      def dependency_map
        specs.each.with_object({}) { |spec, acc| acc[spec.name] = spec.dependencies.map(&:name) }
      end

      def dependencies_of(gem, dependencies = [])
        # Recursively get all gems that a gem brings into the env
        map = dependency_map[gem.to_s]
        return [] unless map

        map.each.with_object(dependencies) do |g, acc|
          next if acc.include?(g)

          acc << g
          dependencies_of(g, acc)
        end.sort
      end

      def graph_of(gem)
        # Recursively get all gems that a gem brings into the env
        map = dependency_map[gem.to_s]
        return unless map && !map.empty?

        dependency_map[gem.to_s].each_with_object({}) do |g, acc|
          acc[g] = graph_of(g)
        end
      end
    end
  end
end
