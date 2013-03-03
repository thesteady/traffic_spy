require 'json'
require 'user_agent'

module TrafficSpy
  class RequestParser
    attr_accessor :path_id

    attr_reader :requested_at, :response_time, :referred_by, :request_type,
                :event_id, :browser_id, :os_id,
                :resolution, :ip, :site_id

    def parse(json_payload)
      payload = JSON.parse(json_payload)
      #returns a hash with the format {"url"=>"link", "next"=>"value", etc}
      #below changes keys to symbols for easy use elsewhere
      Hash[payload.map{|(k,v)| [k.to_sym,v]}]
    end

    def initialize(json_payload)
      #puts json_payload.inspect
      payload = parse(json_payload)
      @site_id = find_site_id(payload[:url])
      @path_id = parse_urlpath(payload[:url])

      @event_id = parse_eventName(payload[:eventName], payload[:url])

      user_agent = UserAgent.parse(payload[:userAgent])
      @browser_id = parse_browser(user_agent.browser)
      @os_id = parse_os(user_agent.platform)


      @requested_at = payload[:requestedAt]
      @response_time = payload[:respondedIn]
      @referred_by = payload[:referredBy]
      @request_type = payload[:requestType]


      @ip = payload[:ip]
      @resolution = combine_resolutions(
                                        payload[:resolutionWidth],
                                        payload[:resolutionHeight]
                                        )

      request = Request.new({:url_path_id => @path_id , :event_id => @event_id,
                             :browser_id => @browser_id, :os_id => @os_id,
                             :site_id => @site_id, :requested_at => @requested_at,
                             :response_time => @response_time,
                             :referred_by => @referred_by, :request_type => @request_type,
                             :resolution => @resolution, :ip => @ip})

      request.save
    end

    def combine_resolutions(width, height)
      "#{width} x #{height}"
    end

    def parse_eventName(eventName, url)
      if Event.exists?(eventName)
        Event.find_by_eventName(eventName).id
      else
        event = Event.new({:name=>eventName, :site_id=>@site_id})
        event.save
        Event.find_by_eventName(eventName).id
      end
    end

    def parse_urlpath(urlpath)
      if UrlPath.exists?(urlpath)
        UrlPath.find_by_path(urlpath).id
      else
        path = UrlPath.new({:path => urlpath, :site_id => @site_id})
        path.save
        UrlPath.find_by_path(path.path).id
      end
    end

    def parse_browser(browser)
      if Browser.exists?(browser)
        Browser.find_by_name(browser).id
      else
        new_browser = Browser.new(:name => browser)
        new_browser.save
        Browser.find_by_name(browser).id
      end
    end

    def parse_os(os)
      if OperatingSystem.exists?(os)
        OperatingSystem.find_by_name(os).id
      else
        new_os = OperatingSystem.new(:name =>os)
        new_os.save
        @os_id = OperatingSystem.find_by_name(os).id
      end
    end

    def find_site_id(urlpath)
      split_url = urlpath.split("/")
      rootUrl = "http://" + split_url[2]
      Site.find_by_rootUrl(rootUrl).id
    end

  end
end
