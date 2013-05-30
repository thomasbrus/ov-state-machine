require 'sass'

module OVStateMachine
  module Web
    module Engines
      class SassEngine < Sinatra::Base  
        set :views, File.dirname(__FILE__) + '/../assets/stylesheets'
        
        get '/stylesheets/*.css' do
          sass params[:splat].first.to_sym
        end
      end
    end
  end
end
