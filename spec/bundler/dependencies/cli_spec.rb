require 'spec_helper'

RSpec.describe Bundler::Dependencies::CLI do
  def run_task(name, *args)
    args.concat(%W(--path #{lockfile_path}))
    described_class.start([name, *args])
  end

  subject { run_task(task, *args) }

  describe '#check' do
    let(:task) { :check }
    let(:args) { [] }

    context 'without a minimum' do
      it 'outputs all gems' do
        expect { subject }.to output(<<~STRING).to_stdout
          4 gems scanned; 20 dependencies found

          Unique dependencies per gem:
              7  rubocop
              5  rspec
              2  pry
              0  rake
        STRING
      end
    end

    context 'with a minimum N' do
      let(:args) { %w(--min 5) }

      it 'only outputs gems with at least N dependencies' do
        expect { subject }.to output(<<~STRING).to_stdout
          4 gems scanned; 20 dependencies found
          2 gems with at least 5 dependencies.

          Unique dependencies per gem:
              7  rubocop
              5  rspec
        STRING
      end
    end
  end

  describe '#graph' do
    let(:task) { :graph }
    let(:args) { [] }

    context 'without a gem name' do
      it 'outputs a full dependency graph' do
        expect { subject }.to output(<<~STRING).to_stdout
          pry
            - coderay
            - method_source
          rake
          rspec
            - rspec-core
              - rspec-support
            - rspec-expectations
              - diff-lcs
              - rspec-support
            - rspec-mocks
              - diff-lcs
              - rspec-support
          rubocop
            - jaro_winkler
            - parallel
            - parser
              - ast
            - rainbow
            - ruby-progressbar
            - unicode-display_width
        STRING
      end
    end

    context 'with a gem name' do
      let(:args) { %w(rubocop) }

      it 'outputs only the graph for that gem' do
        expect { subject }.to output(<<~STRING).to_stdout
          rubocop
            - jaro_winkler
            - parallel
            - parser
              - ast
            - rainbow
            - ruby-progressbar
            - unicode-display_width
        STRING
      end
    end
  end
end
