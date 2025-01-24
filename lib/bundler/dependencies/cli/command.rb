# frozen_string_literal: true

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
          self.shell = Thor::Shell::Basic.new unless options.color?
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

          dir = path_dir(options.path)
          SharedHelpers.chdir(dir) if dir
          SharedHelpers.default_lockfile
        end

        def path_dir(path)
          return nil unless path

          Dir.exist?(options.path) ? options.path : File.dirname(options.path)
        end

        def valid_gemfile?(path)
          return false unless path && File.exist?(path)

          File.basename(path).end_with?('.lock', '.locked')
        end

        def without
          (options.without || []).tap do |gems|
            gems.concat(RAILS_GEMS) if options.without_rails?
          end
        end

        def gems
          @gems ||= graph.without(*without)
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
