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
      #halt 404, 'The page you are looking for doesn\'t exist'
      erb :error
    end

    def check_site_exists(params)
      site = Site.new(params)
      site.exists?
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
        # handle event where identifier does not exist in DB

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

      if valid_site?(params[:identifier])

        @site = Site.find({identifier: params[:identifier]})

        ## Most Requested URLs to least requested URLs
        urls = Request.summarize_url_requests_for_site(@site.id)

        # look into extracting this to UrlPath class
        @url_results = urls.inject({}) do |hash, url|
          path = UrlPath.find({id: url[:url_path_id]}).path
          hash[path] = url[:count]
          hash
        end.sort_by{|k, v| v}.reverse

        ## Browser breakdown
        browsers = Request.summarize_browser_requests_for_site(@site.id)

        # look into extracting this to Browser class
        @browser_results = browsers.inject({}) do |hash, browser|
          name = Browser.find({id: browser[:browser_id]}).name
          hash[name] = browser[:count]
          hash
        end.sort_by{|k, v| v}.reverse

        ## OS breakdown
        oss = Request.summarize_os_requests_for_site(@site.id)

        # look into extracting this to OS class
        @os_results = oss.inject({}) do |hash, os|
          name = OperatingSystem.find({id: os[:os_id]}).name
          hash[name] = os[:count]
          hash
        end.sort_by{|k, v| v}.reverse

        @resolutions = Request.summarize_res_requests_for_site(@site.id)


        @res_results = @resolutions.inject({}) do |hash, res|
          #name = OperatingSystem.find({id: url[:os_id]}).name
          hash[res[:resolution]] = res[:count]
          hash
        end.sort_by{|k, v| v}.reverse

        response_hash = Request.summarize_response_times_for_site(@site.id)

        @response_times = response_hash.inject({}) do |hash, (k, v)|
          path = UrlPath.find({id: k}).path
          hash[path] = v
          hash
        end.sort_by{|k, v| v}.reverse
        erb :app_stats
      else
        halt 403, "{\"message\":\"identifier already exists\"}" if site.exists?
      end
    end

    get '/sources/:identifier/urls/:rel_path' do
      if valid_site?(params[:identifier])
        if valid_url?(params[:rel_path], params[:identifier])

          path = "http://#{params[:identifier]}.com/#{params[:rel_path]}"

          url = UrlPath.find(path: path)
          @url_results = UrlPath.url_response_times(url)
          erb :url_stats
        end
      end
    end

    post '/sources/:identifier/campaigns' do
      if check_site_exists(params) == true
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
        "{\"message\":\"identifier does not exist\"}"
      end
    end

    get '/sources/:identifier/events' do
      if check_site_exists(params) == true
        site_id = Site.find(identifier: :identifier).id
        @events = Event.find_all_by_site_id(site_id)

        if @events.count == 0
          "{\"message\":\"no events have been defined.\"}"
        else
          erb :events
        end

      else
        status 404
        "{\"message\":\"identifier does not exist\"}"
      end
    end

    # get '/sources/:identifier/campaigns' do
    #   if check_site_exists(params) == true
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
    #   if check_site_exists(params) == true
    #   else
    #     status 403
    #       "{\"message\":\"identifier does not exist\"}"
    #   end
    # end

    helpers do
      def valid_site?(identifier)
        site = Site.find(identifier: identifier)
        if site.nil?
           halt 403, "{\"message\":\"identifier does not exist\"}"
         else
          true
         end
      end

      def valid_url?(rel_path, identifier)

        full_path = "http://#{identifier}.com/#{rel_path}"
        path = UrlPath.find(path: full_path)
        if path.nil?
          halt 403, "{\"message\":\"url does not exist\"}"
        else
          true
        end
      end
    end

  end
end
