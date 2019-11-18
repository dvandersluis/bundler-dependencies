require 'spec_helper'
require 'matchers/output_help'

RSpec.describe Bundler::Dependencies::CLI do
  def run_task(name, *args)
    args.concat(%W(--path #{lockfile_path}))
    described_class.start([name, *args])
  end

  subject { run_task(task, *args) }

  describe '#count' do
    let(:task) { :count }
    let(:args) { [] }

    context 'without a minimum' do
      it 'outputs all gems' do
        expect { subject }.to output(<<~STRING).to_stdout
          5 gems scanned; 20 dependencies found

          Unique dependencies per gem:
              8  rubocop-rspec
              7  rubocop
              5  rspec
              2  pry
              0  rake
        STRING
      end
    end

    context 'with a minimum N' do
      let(:args) { %w(--minimum 5) }

      it 'only outputs gems with at least N dependencies' do
        expect { subject }.to output(<<~STRING).to_stdout
          5 gems scanned; 20 dependencies found
          3 gems with at least 5 dependencies.

          Unique dependencies per gem:
              8  rubocop-rspec
              7  rubocop
              5  rspec
        STRING
      end
    end

    context 'when excluding gems' do
      let(:args) { %w(--without rubocop pry) }

      it 'does not output excluded gems' do
        expect { subject }.to output(<<~STRING).to_stdout
          5 gems scanned; 20 dependencies found
          3 gems found after applying exclusions.

          Unique dependencies per gem:
              5  rspec
              0  rubocop-rspec
              0  rake
        STRING
      end
    end

    context 'when passed help' do
      let(:args) { %w(help) }

      it 'outputs the help' do
        expect { subject }.to output_help(:count)
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
          rubocop-rspec
            - rubocop
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

    context 'with a gem not in the bundle' do
      let(:args) { %w(foo) }

      it 'outputs an error' do
        expect { subject }.to raise_error(SystemExit).
          and output(<<~STRING).to_stderr
            foo is not present in your bundle.
          STRING
      end
    end

    context 'when passed help' do
      let(:args) { %w(help) }

      it 'outputs the help' do
        expect { subject }.to output_help(:graph)
      end
    end
  end

  describe '#find' do
    let(:lockfile) { 'nested.lock' }
    let(:task) { :find }

    context 'for a gem in the bundle' do
      let(:args) { %w(ast) }

      context 'in quiet mode' do
        let(:args) { %w(ast --quiet) }

        it 'outputs the number of dependents' do
          expect { subject }.to output(<<~STRING).to_stdout
            3
          STRING
        end
      end

      context 'in loud mode' do
        it 'outputs all the dependency paths for the gem' do
          expect { subject }.to output(<<~STRING).to_stdout
            3 gems depend on ast:

            codeshift
              * codeshift → parser → ast

            gelauto
              * gelauto → parser → ast

            rubocop_defaults
              * rubocop_defaults → rubocop → parser → ast
              * rubocop_defaults → rubocop-rspec → rubocop → parser → ast
          STRING
        end
      end
    end

    context 'for a gem not in the bundle' do
      let(:args) { 'foo' }

      it 'outputs an error message' do
        expect { subject }.to raise_error(SystemExit).
          and output(<<~STRING).to_stderr
            No gems in the bundle depend on foo.
        STRING
      end
    end

    context 'when passed help' do
      let(:args) { %w(help) }

      it 'outputs the help' do
        expect { subject }.to output_help(:find)
      end
    end
  end
end
