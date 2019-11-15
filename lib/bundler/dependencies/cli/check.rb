module Bundler
  module Dependencies
    class CLI < ::Thor
      class Check < ::Thor
        def initialize(options)
          @options = options
        end

        no_commands do
          def output
            say(scanner.to_s, :bold)
            warnings
            format_counts
          end
        end

      private

        attr_reader :options

        def scanner
          @scanner ||= Scanner.new(options.path)
        end

        def graph
          @graph ||= scanner.graph
        end

        def counts
          @counts ||= graph.without(*options.without).counts(min: options.minimum)
        end

        def warnings
          warn("#{counts.count} gems with at least #{options.minimum} dependencies.") if options.minimum > 0
          warn("#{counts.count} gems found after applying exclusions.") if options.without
        end

        def format_counts
          puts "\nUnique dependencies per gem:"

          counts.each do |gem, count|
            puts format('%5d  %s', count, gem) unless gem == File.basename($PROGRAM_NAME)
          end
        end

        def warn(message)
          say(message, %i(bold yellow))
        end
      end
    end
  end
end
