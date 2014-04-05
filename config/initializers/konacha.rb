if defined?(Konacha)
  require 'capybara/poltergeist'
  Konacha.configure do |config|
    config.driver = :poltergeist
    config.port   = 50093

    Capybara.server do |app, port|
      require 'rack/handler/thin'
      Rack::Handler::Thin.run(app, Port: port)
    end
  end
end
