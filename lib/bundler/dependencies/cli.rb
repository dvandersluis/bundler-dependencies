require 'thor'
require 'bundler'
require 'bundler/vendored_thor'

require 'bundler/dependencies'

module Bundler
  module Dependencies
    class CLI < ::Thor
      default_task :check
      map '--version' => :version

      desc 'check', 'Checks for gems that install too many dependencies'
      method_option :minimum, type: :numeric, desc: 'Report only gems with a minimum N dependencies', aliases: ['-m', '--min'], default: 0
      method_option :path, type: :string, desc: 'Path to Gemfile.lock to scan', default: Bundler.default_lockfile
      method_option :without, type: :array, desc: 'Gems to ignore', aliases: ['-W']

      def check
        Check.new(options).output
      end

      desc 'graph [GEM]', 'Outputs a dependency graph'
      method_option :path, type: :string, desc: 'Path to Gemfile.lock to scan', default: Bundler.default_lockfile
      method_option :without, type: :array, desc: 'Gems to ignore', aliases: ['-W']

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
