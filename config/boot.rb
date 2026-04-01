ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# After Bundler so we load the Gemfile's logger, not Ruby's default gem (version mismatch).
# Still before bootsnap / application so Logger is defined before ActiveSupport loads.
require "logger"

require "bootsnap/setup" # Speed up boot time by caching expensive operations.
