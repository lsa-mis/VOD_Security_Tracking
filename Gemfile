source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'
gem 'rails', '~> 8.1'

gem 'activeadmin', '~> 4.0.0.beta18'
gem 'audited', '~> 5.8'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', '~> 4.9'
gem 'devise_ldap_authenticatable'
gem 'duo_web', '~> 1.0'
gem 'google-cloud-storage', require: false
gem 'hotwire-rails'
gem 'jbuilder', '~> 2.11'
gem 'jsbundling-rails'
gem 'ldap_fluff', '~> 0.6.0'
gem 'ldap_lookup', '~> 0.1.5'
gem 'lsa_tdx_feedback'
# gem install mysql2 -v '0.5.6' -- --with-opt-dir=/opt/homebrew/opt/openssl@3:/opt/homebrew/opt/mysql:/opt/homebrew/opt/zstd
gem 'mysql2', '~> 0.5.6'
gem 'nokogiri', '>= 1.15.0'
gem 'pagy', '~> 8.0'
gem 'puma', '~> 6.4'
gem 'pundit', '~> 2.3'
gem 'redis', '~> 5.0'
gem 'ransack', '~> 4.1', '>= 4.1.1'
gem 'responders', '~> 3.1'
gem 'ruby2_keywords'
gem 'sass-rails', '>= 6'
# Allows puma to use notify in systemd
gem 'sd_notify', '~> 0.1.1'
gem 'simple_form', '~> 5.3'
gem 'turnout', '~> 2.5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'psych', '< 4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 6.0'
end

group :development do
  gem 'annotate'
  gem 'capistrano', '~> 3.18',         require: false
  gem 'capistrano-rails', '~> 1.6', '>= 1.6.1',   require: false
  gem 'capistrano-asdf',   require: false
  gem 'listen', '~> 3.9'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'spring'
  gem 'stringio', '~> 3.1'
  gem 'web-console', '>= 4.2'
end

group :test do
  gem "capybara", ">= 3.40"
  gem "selenium-webdriver"
  gem 'webmock', '~> 3.23'
  gem 'vcr', '~> 6.2'
end
