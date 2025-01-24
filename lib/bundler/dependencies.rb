# frozen_string_literal: true

require 'bundler/dependencies/version'

require 'bundler'

require 'bundler/dependencies/cli'
require 'bundler/dependencies/graph'
require 'bundler/dependencies/scanner'
require 'bundler/dependencies/spec'
require 'bundler/dependencies/visitor'

require 'bundler/dependencies/cli/command'
require 'bundler/dependencies/cli/with_gem'
require 'bundler/dependencies/cli/count'
require 'bundler/dependencies/cli/find'
require 'bundler/dependencies/cli/graph'

require 'bundler/dependencies/visitors/shell_tree'
require 'bundler/dependencies/visitors/paths'

module Bundler
  module Dependencies
  end
end
