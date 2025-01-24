# frozen_string_literal: true

require 'rspec/matchers/built_in/output'

RSpec::Matchers.define(:output_help) do |command|
  match do |block|
    @command = command
    @block = block
    RSpec::Matchers::BuiltIn::Output.new(help).to_stdout.matches?(block)
  end

  def supports_block_expectations?
    true
  end

  def help
    RSpec::Matchers::BuiltIn::CaptureStdout.capture(-> { described_class.new.help(@command) })
  end
end
