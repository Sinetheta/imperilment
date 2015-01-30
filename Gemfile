source 'http://rubygems.org'

gem 'rails', '~> 4.2.0'

gem 'devise'
gem 'omniauth-openid'
gem 'rolify'
gem 'cancancan'

gem 'simple_form', '3.1.0'
gem 'show_for'

gem 'will_paginate'
gem 'select2-rails'

gem 'sass-rails', '~> 5.0.0'
gem 'coffee-rails'

gem 'jquery-rails'

gem 'bootstrap-sass', '~> 3.2.0'
gem 'bootstrap-datepicker-rails'

gem 'font-awesome-rails'

gem 'uglifier'

gem 'datejs-rails'

gem 'redcarpet'

gem 'dotenv-rails'
gem 'oops', github: 'freerunningtech/oops'

gem 'skylight'
gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof'
gem 'memory_profiler'

group :development do
  gem 'quiet_assets'
  gem 'letter_opener'

  gem 'guard-bundler'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'guard-konacha'
  gem 'guard-spring', github: 'mknapik/guard-spring'

  gem 'thin'
end

group :development, :test do
  gem 'pry-rails'
  gem 'ffaker'
  gem 'sqlite3'
end

group :test do
  gem 'capybara'
  gem 'minitest' # To get rid of errors
  gem 'shoulda-matchers'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activemodel-mocks'
  gem 'factory_girl_rails', :require => false
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'timecop'

  gem 'konacha'
  gem 'konacha-chai-matchers'
  gem 'ejs'
  gem 'poltergeist'
end

group :production do
  gem 'mysql2'
  gem 'exception_notification'
  gem 'unicorn'
end
