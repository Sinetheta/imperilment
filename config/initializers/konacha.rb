Konacha.configure do |config|
  config.driver = :poltergeist
  config.port   = 50093
end if defined?(Konacha)
