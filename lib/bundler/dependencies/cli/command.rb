module Bundler
  module Dependencies
    class CLI < ::Thor
      class Command < ::Thor
        def initialize(options)
          @options = options
        end

        no_commands do
          def output
            to_s
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

        def warn(message)
          say(message, %i(bold yellow))
        end
      end
    end
  end
end
