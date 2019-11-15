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

      def check
        scanner = Scanner.new(options.path)
        counts = scanner.counts(min: options.minimum)

        say(scanner.to_s, :bold)
        output_counts(counts)
      end

      desc 'graph [GEM]', 'Outputs a dependency graph'
      method_option :path, type: :string, desc: 'Path to Gemfile.lock to scan', default: Bundler.default_lockfile

      def graph(gem = nil)
        scanner = Scanner.new(options.path)
        graph = gem ? [Spec.find(gem)] : scanner.graph
        Visitors::ShellTree.new.walk(graph, shell)
      end

      desc 'version', 'Prints the bundler-dependencies version'
      def version
        puts "#{File.basename($PROGRAM_NAME)} #{VERSION}"
      end

    protected

      def print_warning(message)
        say(message, :yellow)
      end

      def output_counts(counts)
        say("#{counts.count} gems with at least #{options.minimum} dependencies.", %i(bold yellow)) if options.minimum > 0

        counts.each do |gem, count|
          next if gem == File.basename($PROGRAM_NAME)

          puts "  #{gem}: #{count}"
        end
      end
    end
  end
end
