# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/dependencies'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.filter_run_when_matching(:focus)
  config.disable_monkey_patching!

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end

  config.order = :random
  Kernel.srand(config.seed)

  RSpec.shared_context('setup') do
    let(:lockfile) { 'Gemfile.lock' }
    let(:lockfile_path) { File.expand_path("support/Gemfiles/#{lockfile}", __dir__) }
    let!(:scanner) { Bundler::Dependencies::Scanner.new(lockfile_path) }
    let(:graph) { scanner.graph }
  end

  config.include_context('setup')

  config.include(Module.new do
    def walk(graph)
      puts Bundler::Dependencies::Visitors::ShellTree.new.walk(graph)
    end
  end)
end

Thor::Base.shell = Thor::Shell::Basic
