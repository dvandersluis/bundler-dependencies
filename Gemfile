# frozen_string_literal: true

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

source 'https://rubygems.org'

# Specify your gem's dependencies in bundler-dependencies.gemspec
gemspec

gem 'pry'
gem 'rake'
gem 'rspec'
gem 'rubocop'
gem 'rubocop-performance'
gem 'rubocop-rspec'

plugin 'bundler-dependencies', path: '.' unless ENV['CI']
