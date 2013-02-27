require 'sinatra/base'

module TrafficSpy
  class Application < Sinatra::Base
    post '/sources' do
      if params[:rootUrl].nil?
        status 400
        "{\"message\":\"no url provided\"}"
      elsif params[:identifier].nil?
        status 400
        "{\"message\":\"no identifier provided\"}"
      else
        "{\"identifier\":\"#{params[:identifier]}\"}"
      end
    end
  end
end
