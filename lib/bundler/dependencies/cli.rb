require 'thor'
require 'bundler'
require 'bundler/vendored_thor'

require 'bundler/dependencies'

module Bundler
  module Dependencies
    class CLI < ::Thor
      def self.shared_options
        method_option :path, type: :string, desc: 'Path to Gemfile.lock to scan'
        method_option :without, type: :array, desc: 'Gems to ignore', aliases: ['-W']
        method_option :without_rails, type: :boolean, default: false, desc: 'Ignore all Rails gems', aliases: ['-R']
      end

      default_task :count
      map '--version' => :version

      desc 'count', 'Checks for gems that install too many dependencies'
      shared_options
      method_option :minimum, type: :numeric, desc: 'Report only gems with a minimum N dependencies', aliases: ['-m'], default: 0

      def count
        Count.new(options).output
      end

      desc 'graph [GEM]', 'Outputs a dependency graph'
      shared_options

      def graph(gem = nil)
        Graph.new(gem, options).output
      end

      desc 'version', 'Prints the bundler-dependencies version'
      def version
        puts "#{File.basename($PROGRAM_NAME)} #{VERSION}"
      end
    end
  end
end
