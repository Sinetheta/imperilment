# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
if Rails.env.test? || Rails.env.development?
  Imperilment::Application.config.secret_key_base = '24b285ee6fec07ce506a7ccc476a53c71b8c015faea316904135474b5649285f3b33388ad06956fe7f0e5c362151c6668fe54720678eb88a32f39f6b259fa8ab'
else
  raise "You must set a secret token in ENV['SECRET_TOKEN'] or in config/initializers/secret_token.rb" if ENV['SECRET_TOKEN'].blank?
  Imperilment::Application.config.secret_key_base = ENV['SECRET_TOKEN']
end
