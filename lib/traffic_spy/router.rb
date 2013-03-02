module TrafficSpy
  class Router < Sinatra::Base
    #set :views, 'lib/views'

    post '/sources' do

      if params[:rootUrl].nil?
        status 400
        "{\"message\":\"no url provided\"}"

      elsif params[:identifier].nil?
        status 400
        "{\"message\":\"no identifier provided\"}"

      elsif Site.exists?(params[:identifier])
        status 403
        "{\"message\":\identifier already exists\"}"
      else
        site = Site.new(params)
        site.save
        "{\"identifier\":\"#{params[:identifier]}\"}"
      end
    end

    post '/sources/:identifier/data' do
      # if identifier doesnt already exist, provide send 403 message
      # else parse payload
    end

  end
end
