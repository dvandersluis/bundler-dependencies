# frozen_string_literal: true

module Bundler
  module Dependencies
    class CLI < ::Thor
      class Find < Command
        include WithGem

        private

        def to_s
          if dependents.empty?
            error("No gems in the bundle depend on #{gem}.")
            exit(1)
          end

          banner
          paths unless options.quiet
        end

        def dependents
          Bundler::Dependencies::Visitors::Paths.new.walk(gems, gem).each_with_object({}) do |path, acc|
            acc[path.first] ||= []
            acc[path.first] << path.join(' → ')
          end
        end

        def paths
          dependents.each do |gem, paths|
            puts
            say(gem, %i[bold])
            paths.each { |p| say "  * #{p}" }
          end
        end

        def banner
          if options.quiet?
            puts dependents.count
          else
            say("#{dependents.count} gems depend on #{gem}:", :bold)
          end
        end
      end
    end
  end
end
