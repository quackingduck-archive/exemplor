require 'rack/test'

class Exemplor::Environment
  include Rack::Test::Methods

  # Public: Sets the target app for rack/test
  #
  # Examples
  #
  #   # Sinatra
  #   eg.app(Sinatra::Application)
  #   # Rails
  #   eg.app(ActionController::Dispatcher.new)
  #
  def self.app(app)
    @@app = app
  end

  def app
    @@app
  end
end