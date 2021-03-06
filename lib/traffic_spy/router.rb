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
        halt 400, "{\"message\":\"missing a parameter\"}" if !site.valid?
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
        @res_results = site_summary.res_results
        @response_times = site_summary.response_times

        erb :app_stats
      # else
      #   halt 403, "{\"message\":\"identifialready exists\"}" if site.exists?
      end
    end


    post '/sources/:identifier/data' do
      if valid_site?(params)
        payload = params[:payload]
        check_payload(payload)
      # else
      #   halt 403, "{\"message\":\"identifier does not exist\"}"
      end
    end

    # get '/sources/:identifier/urls.json', :provides => :json do

    #   content_type :json

    #   if valid_site?(params) #&& valid_url?(params)

    #     site_id = Site.find({identifier: params[:identifier]}).id

    #     #raise "site_id: #{site_id}"

    #      @urls = UrlPath.find_all({site_id: site_id}).map do |url|
    #       url[:path]
    #     end

    #     @urls.to_json
    #   end
    # end


    get '/sources/:identifier/urls/*' do

      if valid_site?(params) && valid_url?(params)
        rootUrl = Site.find({identifier: params[:identifier]}).rootUrl

        @path = "#{rootUrl}/#{params[:splat].join}"

        url = UrlPath.find(path: @path)
        @url_results = UrlPath.url_response_times(url)
        erb :url_stats
      end
    end

    post '/sources/:identifier/campaigns' do
      if valid_site?(params)
        check_campaign_components(params)
      # else
      #   halt 403, "{\"message\":\"identifier does not exist\"}"
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
          halt 403, "{\"message\":\"No campaigns have been defined.\"}"
        end
      else
        halt 403, "{\"message\":\"identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/campaigns/:campaignname' do
      if valid_site?(params)
        site_id = Site.find(identifier: params[:identifier]).id
        campaign = Campaign.new(name: params[:campaignname], site_id: site_id)

        if campaign.exists?

          camp = Campaign.get_campaign_id(name: campaign.name,
                                          site_id: campaign.site_id
                                          )
          @events = camp.events

          @campaign_results = Request.summarize_campaign_events(@events)
          erb :campaign_detail
        else
          halt 403, '{"message":"Campaign has not been defined."}'
        end
      else
        halt 403, "{\"message\":\"identifier does not exist\"}"
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
        #identifier = params[:identifier]
        rel_path = params[:rel_path]
        site = Site.find({identifier: params[:identifier]})

        full_path = "#{site.rootUrl}/#{rel_path}"

        path = UrlPath.find(path: full_path)


        if path.nil?
          halt 403, "{\"message\":\"url does not exist\"}"
        else
          #raise "true"
          true
        end

      end

      def valid_event?(params)

        identifier = params[:identifier]
        event_name = params[:event_name]

        site_id = Site.find(identifier: identifier).id
        event = Event.find({name: event_name}, {site_id: site_id})
        if event.nil?
          halt 403, "{\"message\":\"given event has not been defined\"}"
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
        if campaign.missing_name? || params[:eventNames].nil?
          halt 400, '{"message":"missing parameter campaignName or eventNames"}'
        elsif !campaign.exists?
          campaign_id = campaign.save
          events = find_events_for_campaign(params[:eventNames], site_id)
          results = create_campaign_events(events, campaign_id)
          status 200
        else
          halt 403, "{\"message\":\"campaign already exists\"}"
        end
      end

      def find_events_for_campaign(event_names, site_id)
          event_names.map {|name| Event.find_all_by_site_id(site_id)}
      end

      def create_campaign_events(events, campaign_id)
        events.flatten.each do |event|
          c=CampaignEvent.new(campaign_id: campaign_id, event_id: event[:id])
          c.save
        end
      end

    end

  end
end
