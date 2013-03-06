module TrafficSpy
  class Router < Sinatra::Base
    set :views, './lib/traffic_spy/views'

    get '/' do
      @title = "TrafficSpy Analytics Summary"
      erb :index
    end

    get '/sources' do
      @title = "Source List"
      @sites = TrafficSpy::Site.all
      erb :list
    end

    get '/about_us' do
      "Coming Soon"
    end

    not_found do
      erb :error
    end

    post '/sources' do
      site = Site.new(params)

      if site.save
        "{\"identifier\":\"#{params[:identifier]}\"}"
      else
        halt 400, "{\"message\":\"missing a parameter: provide identifier and rootUrl\"}" if !site.valid?
        halt 403, "{\"message\":\"identifier already exists\"}" if site.exists?
      end
    end

    post '/sources/:identifier/data' do
      if valid_site?(params)
        payload = params[:payload]
        check_payload(payload)
      else
        halt 403, "{\"message\":\"identifier does not exist\"}"
      end
    end

    get '/sources/:identifier' do
      if valid_site?(params)
        @site = Site.find({identifier: params[:identifier]})
        site_summary = SiteSummary.new(@site)

        @url_results = site_summary.url_results
        @browser_results = site_summary.browser_results
        @os_results = site_summary.os_results
        @res_results = site_summary.os_results
        @response_times = site_summary.response_times

        erb :app_stats
      else
        halt 403, "{\"message\":\"identifier already exists\"}" if site.exists?
      end
    end

    get '/sources/:identifier/urls/:rel_path' do
      if valid_site?(params)
        if valid_url?(params)

          path = "http://#{params[:identifier]}.com/#{params[:rel_path]}"

          url = UrlPath.find(path: path)
          @url_results = UrlPath.url_response_times(url)
          erb :url_stats
        end
      end
    end

    # post '/sources/:identifier/campaigns' do
    #   if valid_site?(params[:identifier])
    #     if params[:campaignName].exists?
    #       status 403
    #       "{\"message\":\"Campaign Already Exists\"}"
    #     elsif params[:campaignName].nil?
    #       status 400
    #       "{\"message\":\"missing parameter CampaignName\"}"
    #     elsif params[:eventNames].nil?
    #       status 400
    #       "{\"message\":\"missing parameter EventNames\"}"
    #     else
    #       status 200
    #       "{\"message\":\"campaign created\"}"
    #     end

    #   else
    #     status 403
    #     "{\"message\":\"identifier does not exist\"}"
    #   end
    # end

    get '/sources/:identifier/events' do
      identifier = params[:identifier]

      if valid_site?(params) && any_events_listed?(params)

        site = Site.find({identifier: params[:identifier]})
        site_summary = SiteSummary.new(site)
        @event_results = site_summary.event_results

        erb :events
      end
    end

    get '/sources/:identifier/events/:event_name' do
      if valid_site?(params) && valid_event?(params)

        site_id = Site.find(identifier: params[:identifier]).id
        event = Event.find({name: params[:event_name]},{site_id: site_id})

        @grouped_hours = event.dates_grouped_by_hour
        erb :event_detail
      end
    end

    # get '/sources/:identifier/campaigns' do
    #   if valid_site?(params[:identifier]) == true
    #     site_id = Site.find(identifier: :identifier).identifier
    #     @campaigns = Campaign.find_all_by_site_id(site_id)
    #     if @campaigns.count == 0
    #       "{\"message\":\"no campaigns defined\"}"
    #     else
    #       erb :campaigns
    #     end
    #   else
    #     status 403
    #       "{\"message\":\"identifier does not exist\"}"
    #   end
    # end

    # get '/sources/:identifier/campaigns/:campaignname' do
    #   if valid_site?(params[:identifier]) == true
    #   else
    #     status 403
    #       "{\"message\":\"identifier does not exist\"}"
    #   end
    # end

    helpers do

      def payload_is_redundant?(payload)
        parsed_payload = TrafficSpy::RequestParser.new(payload)
        new_request = Request.new(parsed_payload.req_attributes)
        new_request.exists?
      end

      def valid_site?(params)
        site = Site.find(identifier: params[:identifier])
        if site.nil?
          halt 403, "{\"message\":\"identifier does not exist\"}"
         else
          true
         end
      end

      def valid_url?(params)
        identifier = params[:identifier]
        rel_path = params[:rel_path]

        full_path = "http://#{identifier}.com/#{rel_path}"
        path = UrlPath.find(path: full_path)
        if path.nil?
          halt 403, "{\"message\":\"url does not exist\"}"
        else
          true
        end
      end

      def valid_event?(params)

        identifier = params[:identifier]
        event_name = params[:event_name]

        site_id = Site.find(identifier: identifier).id
        event = Event.find({name: event_name}, {site_id: site_id})
        if event.nil?
          halt 403, "{\"message\":\"No event with the given name has been defined\"}"
        else
          true
        end
      end

      def check_payload(payload)
        if payload.nil?
          halt 400, "{\"message\":\"payload was empty\"}"
        elsif payload_is_redundant?(payload)
          halt 403, "{\"message\":\"payload has already been submitted\"}"
        else
          TrafficSpy::RequestParser.new(payload).create_request
          "Success"
        end
      end

      def any_events_listed?(params)

        identifier = params[:identifier]
        site_id = Site.find(identifier: identifier).id

        events = Event.find_all_by_site_id(site_id)

        if events.empty?
          halt 403, "{\"message\":\"No events have been defined.\"}"
        else
          true
        end
      end
    end

  end
end
