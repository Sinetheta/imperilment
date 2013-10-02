source 'http://rubygems.org'

ruby '1.9.3'

gem 'rails', '~> 4.0.0'

gem 'devise'
gem 'omniauth-openid'
gem 'rolify', '~> 3.3.0.rc4'
gem 'cancan', :git => 'https://github.com/3months/cancan', :branch => 'strong_parameters'

gem 'squeel'

gem 'simple_form'
gem 'show_for'

gem 'will_paginate'
gem 'select2-rails'

gem 'sass-rails'
gem 'coffee-rails'

gem 'jquery-rails'

gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'

gem 'font-awesome-sass-rails'

gem 'uglifier'

gem 'datejs-rails'

gem 'redcarpet'

# Heroku Rails 4 Compatibility
gem 'rails_12factor'

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


  gem 'hirb'
  gem 'wirb'
  gem 'meta_request'

  gem 'thin'
end

group :development, :test do
  gem 'shoulda-matchers'
  gem 'rspec-rails'
  gem 'factory_girl_rails', :require => false
  gem 'rb-inotify', '~> 0.9'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'sqlite3'
  gem 'timecop'

  gem 'pry', github: 'pry/pry'
  gem 'pry-plus'

  gem 'fuubar'
  gem 'konacha'
  gem 'konacha-chai-matchers'
  gem 'ejs'
  gem 'poltergeist'
end

group :production do
  gem 'pg'
  gem 'exception_notification'
  gem 'unicorn'
end
