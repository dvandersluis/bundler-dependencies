lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundler/dependencies/version'

Gem::Specification.new do |spec|
  spec.name          = 'bundler-dependencies'
  spec.version       = Bundler::Dependencies::VERSION
  spec.authors       = ['Daniel Vandersluis']
  spec.email         = ['daniel.vandersluis@gmail.com']
  spec.licenses      = ['MIT']

  spec.summary       = 'Find gems in your Gemfile with too many dependencies'
  spec.homepage      = 'https://github.com/dvandersluis/bundler-dependencies'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = spec.homepage
    spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGES.md"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 2.0'
  spec.add_dependency 'thor', '~> 0.20.3'

  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.76.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.36.0'
end
