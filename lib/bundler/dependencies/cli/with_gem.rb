# frozen_string_literal: true

module Bundler
  module Dependencies
    class CLI < ::Thor
      module WithGem
        def initialize(gem, options)
          @gem = gem
          super(options)
        end

        private

        attr_reader :gem
      end
    end
  end
end
