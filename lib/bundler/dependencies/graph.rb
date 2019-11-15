module Bundler
  module Dependencies
    class Graph
      include Enumerable

      def initialize(lockfile)
        @lockfile = lockfile
        load_specs
      end

      def each(&block)
        gems.each(&block)
      end

    private

      attr_reader :lockfile

      def gems
        lockfile.dependencies.keys.map { |name| Spec.new(name) }
      end

      def load_specs
        @specs = lockfile.specs.each_with_object([]) do |spec, acc|
          acc << Spec.new(spec.name, spec.dependencies)
        end
      end
    end
  end
end
