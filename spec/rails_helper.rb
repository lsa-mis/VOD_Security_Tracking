# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers

  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect, :should]
  end

  # Configure assets for system tests
  config.before(:suite) do
    # Clean existing assets
    FileUtils.rm_rf(Rails.root.join('public', 'assets'))
    FileUtils.rm_rf(Rails.root.join('tmp/cache'))

    # Build JavaScript only
    system('yarn install')
    system('yarn build')
  end

  config.after(:suite) do
    FileUtils.rm_rf(Rails.root.join('public', 'assets'))
    FileUtils.rm_rf(Rails.root.join('tmp/cache'))
  end

  # Use test layout for system tests
  config.before(:each, type: :system) do
    ApplicationController.layout 'application_test'
  end
end

# Configure Capybara
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# Configure test environment
Rails.application.configure do
  config.assets.enabled = true
  # Only compile assets for system tests, not request specs
  config.assets.compile = false
  config.assets.css_compressor = nil
  config.assets.js_compressor = nil
end
