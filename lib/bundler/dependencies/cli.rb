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
        counts = scanner.counts(options.minimum)

        say("#{scanner.gem_count} gems scanned; #{scanner.spec_count} dependencies found", :bold)
        say("#{counts.count} gems with at least #{options.minimum} dependencies.", [:bold, :yellow]) if options.minimum > 0

        counts.each do |gem, count|
          next if gem == File.basename($PROGRAM_NAME)
          puts "  #{gem}: #{count}"
        end
      end

      desc 'graph [GEM]', 'Outputs a dependency graph'
      method_option :path, type: :string, desc: 'Path to Gemfile.lock to scan', default: Bundler.default_lockfile

      def graph(gem = nil)
        scanner = Scanner.new(options.path)
        graph = gem ? { gem => scanner.send(:graph_of, gem) } : scanner.graph
        walk_graph(graph)
      end

      desc 'version', 'Prints the bundler-dependencies version'
      def version
        puts "#{File.basename($PROGRAM_NAME)} #{VERSION}"
      end

    protected

      def say(message = '', color = nil)
        color = nil unless $stdout.tty?
        super(message.to_s, color)
      end

      def print_warning(message)
        say(message, :yellow)
      end

    private

      def walk_graph(graph, level = 0)
        graph.each do |name, children|
          if level > 0
            print '  ' * level
            print '- '
          end

          say(name, (:bold if level == 0))
          walk_graph(children, level + 1) if children
        end
      end
    end
  end
end
