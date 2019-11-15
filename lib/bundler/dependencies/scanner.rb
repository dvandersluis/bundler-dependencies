module Bundler
  module Dependencies
    class Scanner
      attr_reader :graph

      def initialize(path = Bundler.default_lockfile)
        @lockfile = LockfileParser.new(Bundler.read_file(path))
        @graph = Graph.new(lockfile: lockfile)
      end

      def gem_count
        gems.count
      end

      def spec_count
        specs.count
      end

      def to_s
        "#{gem_count} gems scanned; #{spec_count} dependencies found"
      end

    private

      attr_reader :lockfile

      def gems
        lockfile.dependencies.keys
      end

      def specs
        lockfile.specs
      end
    end
  end
end
