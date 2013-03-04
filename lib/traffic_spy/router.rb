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

      if Site.exists?(:identifier)
        # parse payload
        #HERE
       "{\"message\":\"payload has been parsed.\"}"
      else
        status 403
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

################ GET METHODS ##########################
    get '/sources/:identifier' do
      if Site.exists?(:identifier)
        #do we call methods here to grab the data?
        erb :index
      else
      status 404
      "{\"message\":\identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/events' do
      if Site.exists?(:identifier)
        site_id = Site.find_by_identifier(:identifier).id
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
      if Site.exists?(:identifier)
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
      if Site.exists?(:identifier)
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

  end
end
