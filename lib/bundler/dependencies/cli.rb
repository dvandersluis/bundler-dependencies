# frozen_string_literal: true

require 'thor'
require 'bundler'
require 'bundler/vendored_thor'

require 'bundler/dependencies'

module Bundler
  module Dependencies
    class CLI < ::Thor
      package_name 'bundler-dependencies'

      def self.shared_options
        method_option :path, type: :string, desc: 'Path to Gemfile.lock to scan'
        method_option :without, type: :array, desc: 'Gems to ignore', aliases: ['-W']
        method_option :without_rails, type: :boolean, default: false, desc: 'Ignore all Rails gems', aliases: ['-R']
        method_option :color, type: :boolean, default: true, desc: 'Colorize output'
      end

      def self.exit_on_failure?
        true
      end

      def self.basename
        'bundle dependencies'
      end

      default_task :count
      map '--version' => :version
      map '--help' => :help
      map '-h' => :help
      map '-?' => :help

      desc 'version', 'Prints the bundler-dependencies version'
      def version
        puts "#{File.basename($PROGRAM_NAME)} #{VERSION}"
      end

      desc 'count', 'Count the number of dependencies each gem in the bundle relies on, recursively'
      shared_options
      method_option :minimum, type: :numeric, desc: <<~DESC, aliases: ['-m'], default: 0
        Report only gems with a minimum N dependencies
      DESC

      def count(*args)
        return help(:count) if args.first == 'help'

        Count.new(options).output
      end

      desc 'graph [GEM]', 'Output a graph of dependencies, for all gems in the bundle or a specific gem'
      shared_options

      def graph(gem = nil)
        return help(:graph) if gem == 'help'

        Graph.new(gem, options).output
      end

      desc 'find [GEM]', 'Output gems in the bundle that depend on GEM'
      shared_options
      method_option :quiet, type: :boolean, default: false, desc: <<~DESC, aliases: ['-q']
        Show only the number of gems and no other output
      DESC

      def find(gem = nil)
        return help(:find) if gem.nil? || gem == 'help'

        Find.new(gem, options).output
      end
    end
  end
end
