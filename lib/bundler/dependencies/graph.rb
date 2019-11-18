module Bundler
  module Dependencies
    class Graph
      include Enumerable

      def initialize(lockfile: nil, specs: [])
        @lockfile = lockfile

        if lockfile
          load_lockfile
        else
          @specs = specs.compact
        end
      end

      def initialize_copy(source)
        super
        @gems = source.send(:gems).dup
      end

      def empty?
        gems.empty?
      end

      def each(&block)
        gems.each(&block)
      end

      def find(gem)
        include_dependency?(gem) ? Spec.find(gem) : nil
      end

      def counts(min: 0)
        @counts ||= map do |gem|
          count = gem.dependency_count
          next if count < min

          [gem.name, gem.dependency_count]
        end.compact.sort_by(&:last).reverse.to_h
      end

      def delete(*specs)
        specs.each do |gem|
          spec = Spec.new(gem) unless gem.is_a?(Spec)
          gems.delete(spec)
        end
      end

      def include?(gem)
        gem = Spec.new(gem) unless gem.is_a?(Spec)
        gems.include?(gem)
      end

      def include_dependency?(gem)
        gem = Spec.new(gem) unless gem.is_a?(Spec)
        include?(gem) || any? { |spec| spec.include_dependency?(gem) }
      end

      def without(*gems)
        graph = dup
        graph.delete(*gems)
        graph.walk { |gem| gem.dependencies.delete(*gems) }
      end

      def walk(&block)
        Visitor.walk(self, &block)
        self
      end

    private

      attr_reader :lockfile, :specs

      def gems
        @gems ||= if lockfile
          lockfile.dependencies.keys.map { |name| Spec.new(name) }
        else
          specs
        end
      end

      def load_lockfile
        @specs = lockfile.specs.each_with_object([]) do |spec, acc|
          acc << Spec.new(spec.name, spec.dependencies.map(&:name))
        end
      end
    end
  end
end
