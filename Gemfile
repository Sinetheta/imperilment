source 'http://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.1.0.beta'

gem 'devise'
gem 'omniauth-openid'
gem 'rolify', '~> 3.3.0.rc4'
gem 'cancan', :git => 'https://github.com/3months/cancan', :branch => 'strong_parameters'

gem 'simple_form'
gem 'show_for'

gem 'will_paginate'
gem 'select2-rails'

gem 'sass-rails', '~> 4.0.2'
gem 'coffee-rails'

gem 'jquery-rails'

gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'

gem 'font-awesome-sass-rails'

gem 'uglifier'

gem 'datejs-rails'

gem 'redcarpet'

gem 'dotenv-rails'
gem 'oops', github: 'forkata/oops', branch: 'dotenv-support'

group :development do
  gem 'quiet_assets'
  gem 'letter_opener'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'hirb'
  gem 'wirb'
  gem 'meta_request'

  gem 'thin'
end

group :development, :test do
  gem 'guard-livereload'
  gem 'guard-konacha'
  gem 'guard-bundler'
  gem 'guard-rspec', '~> 4.2.0'

  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'minitest' # To get rid of errors
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'ffaker'
  gem 'rspec-rails'

  gem 'factory_girl_rails'
  gem 'simplecov'
  gem 'simplecov-rcov'

  gem 'sqlite3'

  gem 'konacha'
  gem 'konacha-chai-matchers'
  gem 'ejs'
  gem 'poltergeist'

  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-nav'
  gem 'pry-debugger'
end

group :production do
  gem 'mysql2'
  gem 'exception_notification'
  gem 'unicorn'
end
