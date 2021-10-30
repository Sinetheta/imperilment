source 'http://rubygems.org'
ruby '2.4.10'

gem 'bigdecimal', '1.4.2'

gem 'rails', '~> 4.2.8'

gem 'rabl-rails'

gem 'devise'
gem "omniauth-google-oauth2"
gem 'rolify'
gem 'cancancan'

gem 'simple_form', '3.1.0'
gem 'show_for'

gem 'will_paginate'
gem 'select2-rails'

gem 'sass-rails', '~> 5.0.0'
gem 'coffee-rails'

gem 'jquery-rails'

gem 'bootstrap-sass', '~> 3.3.0'
gem 'bootstrap-datepicker-rails'

gem 'fontello_rails_converter'

gem 'uglifier'

gem 'datejs-rails'

gem 'redcarpet'

gem 'inline_svg'

gem 'dotenv-rails'

gem 'slack-notifier'

gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof'
gem 'whenever'

group :development do
  gem 'quiet_assets'
  gem 'letter_opener'
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
  gem 'factory_girl_rails', require: false
  gem 'simplecov', '< 0.19', require: false
  gem 'simplecov-rcov', require: false
  gem 'docile', '< 1.4'
  gem 'timecop'

  gem 'ejs'
  gem 'webmock'
end

group :production do
  gem 'pg', '~> 0.15' # compatibility with ruby 2.4
  gem 'rails_12factor'
  gem 'unicorn'
end
