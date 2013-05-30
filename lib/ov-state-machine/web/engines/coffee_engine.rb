require 'coffee-script'

module OVStateMachine
  module Web
    module Engines
      class CoffeeEngine < Sinatra::Base
        set :views, File.dirname(__FILE__) + '/../assets/javascripts'
        
        get "/javascripts/*.js" do
          coffee params[:splat].first.to_sym
        end  
      end
    end
  end
end
