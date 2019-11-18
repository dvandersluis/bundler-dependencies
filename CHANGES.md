# CHANGELOG

## 0.6.0
* Add `find` command to find all gems in the Gemfile which depend on a given gem.
* Add global `--no-color` switch to disable colorizing output.
* Fix crash when calling `bundle dependencies graph` with a gem that isn't in the bundle.
* Handle invoking a command with help as the first argument (show the command's help).

## 0.5.1
* Fix crash when called without a path argument.
* Fix gemspec not setting up executables properly.

## 0.5.0

Initial version
