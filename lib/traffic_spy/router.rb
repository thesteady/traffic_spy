module TrafficSpy
  class Router < Sinatra::Base
    set :views, './views'

    get '/' do
      @title = "TrafficSpy Analytics Summary"
      erb :index
    end

    get '/sources' do
      @title = "Source List"
      @sites = TrafficSpy::Site.all
      erb :list
    end

    not_found do
      #halt 404, 'The page you are looking for doesn\'t exist'
      erb :error
    end

    post '/sources' do

      site = Site.new(params)
      if site.save
        "{\"identifier\":\"#{params[:identifier]}\"}"
      else
        halt 400, "{\"message\":\"no identifier or rootUrl provided\"}" if site.empty?
        halt 403, "{\"message\":\identifier already exists\"}" if site.exists?
      end
    end

    post '/sources/:identifier/data' do

      # 1) Todo handle empty payload
      # 2) Handle duplicate payload
      # raise "#{params[:payload]}"
      # halt 400, "{\"message\":\"no payload\"}" if params[:payload].empty?

      if valid_site?(params[:identifier])
        TrafficSpy::RequestParser.new(params[:payload]).create_request
       "{\"message\":\"payload has been parsed.\"}"
      end
    end

    get '/sources/:identifier' do
      if Site.exists?(:identifier)
        #do we call methods here to grab the data?
        erb :index
      else
      status 404
      "{\"message\":\identifier does not exist\"}"
      end
    end

    post '/sources/:identifier/campaigns' do
      if Site.exists?(:identifier)

        if params[:campaignName].exists?
          status 403
          "{\"message\":\"Campaign Already Exists\"}"
        elsif params[:campaignName].nil?
          status 400
          "{\"message\":\"missing parameter CampaignName\"}"
        elsif params[:eventNames].nil?
          status 400
          "{\"message\":\"missing parameter EventNames\"}"
        else
          status 200
          "{\"message\":\"campaign created\"}"
        end

      else
        status 403
        "{\"message\":\identifier does not exist\"}"
      end
    end


    # get '/sources/:identifier/events' do
    #   if Site.exists?(:identifier)
    #   #displays events page... do we call methods here to grab data?
    #     #if events have been defined, display page:
    #       #erb :events
    #     #else
    #       #"{\"message\":\ no events have been defined\"}"
    #     #end
    #   else
    #     status 404
    #     "{\"message\":\identifier does not exist\"}"
    #   end
    # end

    # get '/sources/:identifier/campaigns' do
    #   if Site.exists?(:identifier)
    #     #if any campaigns exist
    #       #show page with hyperlinks to campaign specific data
    #       #erb :campaigns
    #     #else
    #       "{\"message\":\no campaigns defined\"}"
    #     #end
    #   else
    #     status 403
    #       "{\"message\":\identifier does not exist\"}"
    #   end
    # end

    # get '/sources/:identifier/campaigns/:campaignname' do
    #   if Site.exists?(:identifier)
    #     #if the specified campaign exists
    #       #show page with info
    #     else
    #       "{\"message\":\no campaign exists\"}"
    #       #hyperlink back to campaigns index
    #     end
    #   else
    #     status 403
    #       "{\"message\":\identifier does not exist\"}"
    #   end
    # end

    helpers do
      def valid_site?(identifier)
        site = Site.find(identifier: identifier)
        if site.nil?
           halt 403, "{\"message\":\identifier does not exists\"}"
         else
          true
         end
      end
    end

  end
end
