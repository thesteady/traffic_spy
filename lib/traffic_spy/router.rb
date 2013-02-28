module TrafficSpy
  class Router < Sinatra::Base
    #set :views, 'lib/views'


    #IDENTIFIER = {:identifier => 'http://jumpstartlab.com'}

    post '/sources' do
      if params[:rootUrl].nil?
        status 400
        "{\"message\":\"no url provided\"}"
      elsif params[:identifier].nil?
        status 400
        "{\"message\":\"no identifier provided\"}"
      elsif params[:identifier] == IDENTIFIER
        status 403
        "{\"message\":\identifier already exists\"}"
      else
        "{\"identifier\":\"#{params[:identifier]}\"}"
      end
    end

  end

end