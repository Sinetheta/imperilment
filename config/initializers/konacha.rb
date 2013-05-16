if defined?(Konacha)
  require 'capybara/poltergeist'
  Konacha.configure do |config|
    config.driver = :poltergeist
    config.port   = 50093
  end
end
