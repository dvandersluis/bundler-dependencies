# frozen_string_literal: true

module Bundler
  module Dependencies
    class Command < Bundler::Plugin::API
      command 'dependencies'

      def exec(_command_name, args)
        Bundler::Dependencies::CLI.start(args)
      end
    end
  end
end
