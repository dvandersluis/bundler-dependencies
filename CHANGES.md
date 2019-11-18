# CHANGELOG

## 0.6.0 (2019-11-18)

### New features
* Add `find` command to find all gems in the Gemfile which depend on a given gem.

### Bug fixes
* Fix crash when calling `bundle dependencies graph` with a gem that isn't in the bundle.

### Changes
* Handle invoking a command with help as the first argument (show the command's help).
* Add global `--no-color` switch to disable colorizing output.

## 0.5.1

### Bug fixes
* Fix crash when called without a path argument.
* Fix gemspec not setting up executables properly.

## 0.5.0

Initial version
