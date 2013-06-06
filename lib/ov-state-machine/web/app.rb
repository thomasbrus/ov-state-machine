require 'sinatra/base'
require 'coffee-script'
require 'sass'

module OVStateMachine
  module Web
    class App < Sinatra::Base
      class AssetEngine < Sinatra::Base
        set :views, File.dirname(__FILE__) + '/assets'
        
        get "/javascripts/*.js" do
          coffee "javascripts/#{params[:splat].first}".to_sym
        end

        get '/stylesheets/*.css' do
          sass "stylesheets/#{params[:splat].first}".to_sym
        end
      end

      # use Faye::RackAdapter, mount: '/faye', timeout: 25
      use AssetEngine

      get '/' do
        erb :index
      end
    end
  end
end
