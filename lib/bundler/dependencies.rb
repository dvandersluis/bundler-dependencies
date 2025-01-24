# frozen_string_literal: true

require 'bundler'

require_relative 'dependencies/version'

require_relative 'dependencies/cli'
require_relative 'dependencies/command'
require_relative 'dependencies/graph'
require_relative 'dependencies/scanner'
require_relative 'dependencies/spec'
require_relative 'dependencies/visitor'

require_relative 'dependencies/cli/command'
require_relative 'dependencies/cli/with_gem'
require_relative 'dependencies/cli/count'
require_relative 'dependencies/cli/find'
require_relative 'dependencies/cli/graph'

require_relative 'dependencies/visitors/shell_tree'
require_relative 'dependencies/visitors/paths'

module Bundler
  module Dependencies
  end
end
