module Bundler
  module Dependencies
    class CLI < ::Thor
      class Command < ::Thor
        RAILS_GEMS = %w(
          rails actioncable actionmailbox actionmailer actionpack actiontext actionview
          activejob activemodel activerecord activestorage activesupport railties
        ).freeze

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

        def without
          (options.without || []).tap do |gems|
            gems.concat(RAILS_GEMS) if options.without_rails?
          end
        end

        def warn(message)
          say(message, %i(bold yellow))
        end
      end
    end
  end
end
