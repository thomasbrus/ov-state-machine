require 'sinatra/base'
require 'coffee-script'
require 'sass'
require 'slim'

module OVStateMachine
  module Web
    class App < Sinatra::Base
      class AssetEngine < Sinatra::Base
        set :views, File.dirname(__FILE__) + '/assets'

        get "/javascripts/*.js" do
          coffee "/javascripts/#{params[:splat].first}".to_sym
        end

        get '/stylesheets/*.css' do
          sass "/stylesheets/#{params[:splat].first}".to_sym
        end
      end

      use AssetEngine

      configure do
        Slim::Engine.default_options[:pretty] = true
      end

      get '/' do
        slim :index
      end
    end
  end
end
