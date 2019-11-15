module Bundler
  module Dependencies
    class Spec
      SPECS = {} # rubocop:disable Style/MutableConstant

      attr_accessor :name, :dependencies

      def self.new(name, dependencies = [])
        name = name.to_sym
        spec = find(name) || super(name, dependencies)
        spec.dependencies = dependencies.map { |d| new(d.name) } if dependencies.any?
        spec
      end

      def self.find(name)
        SPECS[name.to_sym]
      end

      def initialize(name, *)
        @name = name
        @dependencies = []

        SPECS[name] = self
      end

      def flatten
        dependencies.inject([]) do |arr, dependency|
          arr << dependency
          arr.concat(dependency.flatten)
        end.uniq
      end

      def dependency_count
        flatten.count
      end
    end
  end
end
