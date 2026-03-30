source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.9'
gem 'rails', '~> 7.2.3', '>= 7.2.3.1'

gem 'activeadmin', '~> 3.2'
gem 'audited', '>= 5.7'
gem 'bcrypt_pbkdf'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'devise', '~> 5.0'
gem 'devise_ldap_authenticatable'
gem 'duo_web', '~> 1.0'
gem 'ed25519'
gem 'google-cloud-storage', require: false
gem 'hotwire-rails'
gem 'jbuilder', '~> 2.7'
gem 'jsbundling-rails'
gem 'ldap_fluff', '~> 0.6.0'
gem 'ldap_lookup', '~> 0.1.5'
gem 'lsa_tdx_feedback'
# gem install mysql2 -v '0.5.6' -- --with-opt-dir=/opt/homebrew/opt/openssl@3:/opt/homebrew/opt/mysql:/opt/homebrew/opt/zstd
gem 'mysql2', '~> 0.5.6'
gem 'nokogiri', '~> 1.19'
gem 'pagy', '~> 4.10', '>= 4.10.1'
gem 'puma', '~> 7.0'
gem 'pundit', '~> 2.1'
gem 'redis', '~> 5.0'
gem 'ransack', '~> 4.3'
gem 'ruby2_keywords'
gem 'sass-rails', '>= 6'
# Allows puma to use notify in systemd
gem 'sd_notify', '~> 0.1.1'
gem 'simple_form', '~> 5.1'
gem 'turnout', '~> 2.5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'mutex_m'
gem 'drb'
gem 'benchmark'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 7.1'
end

group :development do
  gem 'annotate'
  gem 'capistrano', '~> 3.20.0',         require: false
  gem 'capistrano-rails', '~> 1.6', '>= 1.6.1',   require: false
  gem 'capistrano-asdf',   require: false
  gem 'listen', '~> 3.3'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'spring'
  gem 'stringio', '~> 3.1'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem 'webmock', '~> 3.14'
  gem 'vcr', '~> 6.0'
end
