# frozen_string_literal: true

module Bundler
  module Dependencies
    class CLI < ::Thor
      class Count < Command
        private

        def to_s
          say(scanner.to_s, :bold)
          warnings
          format_counts
        end

        def counts
          @counts ||= gems.counts(min: options.minimum)
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
      end
    end
  end
end
