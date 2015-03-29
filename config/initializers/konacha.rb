if defined?(Konacha)
  require 'capybara/poltergeist'
  Konacha.configure do |config|
    config.driver = :poltergeist
    config.port   = 50_093
  end
end
