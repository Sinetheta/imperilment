source 'http://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 3.2.10'

gem 'devise'
gem 'omniauth-openid'
gem 'rolify'
gem 'cancan'

gem 'squeel'

gem 'simple_form'
gem 'show_for'

gem 'will_paginate'
gem 'will_paginate-bootstrap'

group :test do
  gem 'mocha', '~> 0.12.0', require: false
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  gem 'jquery-rails'

  gem 'bootstrap-sass'
  gem 'bootstrap-datepicker-rails'

  gem 'font-awesome-sass-rails'

  gem 'uglifier'
end

group :development do
  gem 'quiet_assets'
  gem 'letter_opener'

  gem 'guard-bundler'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'guard-konacha'
  gem 'guard-spring', github: 'mknapik/guard-spring'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-full'
  gem 'hirb'
  gem 'wirb'
  gem 'meta_request'

  gem 'thin'
end

group :development, :test do
  gem 'shoulda-matchers'
  gem 'rspec-rails'
  gem 'factory_girl_rails', :require => false
  gem 'rb-inotify', '~> 0.8.8'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'sqlite3'

  gem 'fuubar'
  gem 'konacha'
  gem 'poltergeist'
end

group :production do
  gem 'pg'
  gem 'exception_notification'
  gem 'unicorn'
end
