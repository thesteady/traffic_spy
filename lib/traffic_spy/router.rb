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

    post '/sources' do
      site = Site.new(params)

      if site.save
        { identifier: params[:identifier] }.to_json
        "{\"identifier\":\"#{params[:identifier]}\"}"
      else
        halt 400, "{\"message\":\"missing identifier and rootUrl\"}" if !site.valid?
        halt 403, "{\"message\":\"identifier already exists\"}" if site.exists?
      end
    end

    get '/sources/:identifier.json', :provides => :json do
      content_type :json
     if valid_site?(params)
        @site = Site.find({identifier: params[:identifier]})
        site_summary = SiteSummary.new(@site)

        results = {}

        results[:url_results] = site_summary.url_results
        results[:browser_results] = site_summary.browser_results
        results[:os_results] = site_summary.os_results
        results[:resolution_results] = site_summary.os_results
        results[:response_times] = site_summary.response_times

        results.to_json
      else
        halt 403, "{\"message\":\"identifier already exists\"}" if site.exists?
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


    post '/sources/:identifier/data' do
      if valid_site?(params)
        payload = params[:payload]
        check_payload(payload)
      else
        halt 403, "{\"message\":\"identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/urls.json', :provides => :json do

      content_type :json

      if valid_site?(params) #&& valid_url?(params)

        site_id = Site.find({identifier: params[:identifier]}).id

        #raise "site_id: #{site_id}"

         @urls = UrlPath.find_all({site_id: site_id}).map do |url|
          url[:path]
        end

        @urls.to_json
      end
    end


    get '/sources/:identifier/urls/:rel_path' do
      if valid_site?(params) && valid_url?(params)
          path = "http://#{params[:identifier]}.com/#{params[:rel_path]}"

          url = UrlPath.find(path: path)
          @url_results = UrlPath.url_response_times(url)
          erb :url_stats
      end
    end

    post '/sources/:identifier/campaigns' do
      if valid_site?(params)
        check_campaign_components(params)
      else
        halt 403, "{\"message\":\"identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/events.json', :provides => :json do
      content_type :json
      identifier = params[:identifier]

      if valid_site?(params) && any_events_listed?(params)

        site = Site.find({identifier: params[:identifier]})
        site_summary = SiteSummary.new(site)
        @event_results = site_summary.event_results

        @event_results.to_json

        erb :events
      end
    end

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


    get '/sources/:identifier/campaigns' do
      if valid_site?(params)
        site_id = Site.find(identifier: params[:identifier]).id
        if site_has_campaigns?(site_id)
          @identifier = Site.find(identifier: params[:identifier]).identifier
          @array_of_names = Campaign.get_site_campaign_names(site_id)

          status 200
          erb :campaigns
        else
          '{"message":"No campaigns have been defined."}'
        end
      else
        status 403
          "{\"message\":\"identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/campaigns/:campaignname' do
      if valid_site?(params)
        site_id = Site.find(identifier: params[:identifier]).id
        campaign = Campaign.new(name: params[:campaignname], site_id: site_id)
        if campaign.exists?
          camp = Campaign.get_campaign_id(name: campaign.name, site_id: campaign.site_id)
          @events = camp.events

          event_ids = camp.event_ids
           @campaign_results = Request.summarize_campaign_events(@events)
          erb :campaign_detail
        else
          status 403
          '{"message":"Campaign has not been defined."}'
        end
      else
        status 403
        "{\"message\":\"identifier does not exist\"}"
      end
    end

    not_found do
      erb :error
    end

    def site_has_campaigns?(site_id)
      Campaign.find(site_id: site_id)
    end

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

      def check_campaign_components(params)
        site_id = TrafficSpy::Site.find(identifier: params[:identifier]).id
        campaign = Campaign.new(name: params[:campaignName], site_id: site_id)
        event_names = params[:eventNames]

        if campaign.missing_name? || event_names.nil?
          halt 400, '{"message":"missing parameter campaignName or eventNames"}'
        elsif !campaign.exists?
          campaign_id = campaign.save
          events = event_names.map {|name| Event.find_all_by_site_id(site_id)}

          events.flatten.each do |event|
             CampaignEvent.new(campaign_id: campaign_id, event_id: event[:id]).save
          end
          status 200
        else
          halt 403, "{\"message\":\"campaign already exists\"}"
        end
      end

    end

  end
end
