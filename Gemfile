source 'http://rubygems.org'

gem 'rails', '3.2.9'

gem 'devise'
gem 'omniauth-openid'
gem 'cancan', github: 'ryanb/cancan', branch: '2.0'

gem 'haml-rails'
gem 'simple_form'
gem 'show_for'

gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'simple-navigation-bootstrap'

gem 'sass'

group :test do
  gem 'mocha', '~> 0.12.0', require: false
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  gem 'jquery-rails'
  gem 'bootstrap-sass'

  gem 'uglifier'
end

group :development do
  gem 'quiet_assets'
  gem 'letter_opener'#, github: 'jhawthorn/letter_opener'

  gem 'guard-bundler'
  gem 'guard-livereload'
  gem 'spork'
  gem 'guard-spork'
  gem 'guard-rspec'
end

group :development, :production do
  gem 'thin'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails', :require => false
  gem 'rb-inotify', '~> 0.8.8'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'exception_notification'
end
