# frozen_string_literal: true

require_relative 'lib/bundler/dependencies/version'

Gem::Specification.new do |spec|
  spec.name = 'bundler-dependencies'
  spec.version = Bundler::Dependencies::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.7'
  spec.authors = ['Daniel Vandersluis']
  spec.email = ['daniel.vandersluis@gmail.com']
  spec.licenses = ['MIT']

  spec.summary = 'Find gems in your Gemfile with too many dependencies'
  spec.homepage = 'https://github.com/dvandersluis/bundler-dependencies'

  spec.metadata = {
    'source_code_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/CHANGES.md",
    'bug_tracker_uri' => "#{spec.homepage}/issues",
    'rubygems_mfa_required' => 'true'
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  glob = ->(patterns) { spec.files & Dir[*patterns] }
  spec.executables = glob['bin/bundle*'].map { |path| File.basename(path) }
  spec.default_executable = spec.executables.first if Gem::VERSION < '1.7.'

  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '>= 1', '< 2'
end
