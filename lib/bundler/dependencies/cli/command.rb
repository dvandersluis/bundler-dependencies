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
          rescue Bundler::GemfileNotFound
            error("Could not locate Gemfile at #{SharedHelpers.pwd}.")
          end
        end

      private

        attr_reader :options

        def scanner
          @scanner ||= Scanner.new(path)
        end

        def graph
          @graph ||= scanner.graph
        end

        def path
          return options.path if valid_gemfile?(options.path)

          SharedHelpers.chdir(File.dirname(options.path)) if options.path
          SharedHelpers.default_lockfile
        end

        def valid_gemfile?(path)
          return false unless path && File.exist?(path)

          %w(Gemfile.lock gems.locked).include?(File.basename(path))
        end

        def without
          (options.without || []).tap do |gems|
            gems.concat(RAILS_GEMS) if options.without_rails?
          end
        end

        def warn(message)
          say(message, %i(bold yellow))
        end

        def error(message)
          message = shell.send(:prepare_message, message, :red, :bold)
          super(message)
        end
      end
    end
  end
end
