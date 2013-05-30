require 'sinatra/base'

require_relative './engines/sass_engine'
require_relative './engines/coffee_engine'

module OVStateMachine
  module Web
    class App < Sinatra::Base
      # use Faye::RackAdapter, mount: '/faye', timeout: 25
      use Engines::SassEngine
      use Engines::CoffeeEngine

      get '/' do
        erb :index
      end
    end
  end
end
