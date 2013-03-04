module TrafficSpy
  class Router < Sinatra::Base
    #set :views, 'lib/views'

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
        # handle event where identifier does not exist in DB
        site = Site.new(params)
        if site.exists?
          TrafficSpy::RequestParser.new(params[:payload]).create_request
        "{\"message\":\"payload has been parsed.\"}"
      else
        "{\"message\":\ identifier does not exist\"}"
      end
    end

    post '/sources/:identifier/campaigns' do
      site = Site.new(params)
      if site.exists?
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
        "{\"message\":\ identifier does not exist\"}"
      end
    end

################ GET METHODS ##########################
    get '/sources/:identifier' do
      site = Site.new(params)
      if site.exists?
        #do we call methods here to grab the data?
        erb :index
      else
      status 404
      "{\"message\":\identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/events' do
      site = Site.new(params)
      if site.exists?
        site_id = Site.find(identifier: :identifier).id
        @events = Event.find_all_by_site_id(site_id)

        if @events.count == 0
          "{\"message\":\no events have been defined.\"}"
        else
          erb :events
        end

      else
        status 404
        "{\"message\":\identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/campaigns' do
      site = Site.new(params)
      if site.exists?
        #if any campaigns exist
          #show page with hyperlinks to campaign specific data
          #erb :campaigns
        #else
          "{\"message\":\no campaigns defined\"}"
        #end
      else
        status 403
          "{\"message\":\identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/campaigns/:campaignname' do
      site = Site.new(params)
      if site.exists?
        #if the specified campaign exists
          #show page with info
        # else
        #   "{\"message\":\no campaign exists\"}"
        #   #hyperlink back to campaigns index
        # end
      else
        status 403
          "{\"message\":\identifier does not exist\"}"
      end
    end

    helpers do
      # def validate_site(identifier)
      #   site = Site.find(identifier: identifier)
      #   # if !site.exists?
      #   #    halt 403, "{\"message\":\identifier does not exists\"}"
      #   #  else
      #   #   true
      #   #  end
      # end
    end

  end
end
