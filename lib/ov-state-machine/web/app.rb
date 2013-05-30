require 'sinatra/base'
require 'coffee-script'
require 'sass'

module OVStateMachine
  module Web
    module Engines
      class CoffeeEngine < Sinatra::Base
        set :views, File.dirname(__FILE__) + '/assets/javascripts'
        
        get "/javascripts/*.js" do
          coffee params[:splat].first.to_sym
        end  
      end
    end

    module Engines
      class SassEngine < Sinatra::Base  
        set :views, File.dirname(__FILE__) + '/assets/stylesheets'
        
        get '/stylesheets/*.css' do
          sass params[:splat].first.to_sym
        end
      end
    end

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
