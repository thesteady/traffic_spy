require 'json'
require 'user_agent'

module TrafficSpy
  class RequestParser
    attr_accessor :path_id
    attr_reader :requestedAt, :respondedIn, :referredBy, :requestType,
                :parameters, :eventname_id, :browser_id, :os_id,
                :resolution, :ip, :site_id

    def parse(json_payload)
      payload = JSON.parse(json_payload)
      #returns a hash with the format {"url"=>"link", "next"=>"value", etc}
      #below changes keys to symbols for easy use elsewhere
      Hash[payload.map{|(k,v)| [k.to_sym,v]}]
    end
      
    def initialize(json_payload)
      payload = parse(json_payload)
      
      @site_id = find_site_id(payload[:url])
      @path_id = parse_urlpath(payload[:url])
      @eventname_id = parse_eventName(payload[:eventName], payload[:url])

      user_agent = UserAgent.parse(payload[:userAgent])
      
      browser = Browser.new(:browser => user_agent.browser)
      @browser_id = browser.id
      
      os = OperatingSystem.new(:os =>user_agent.platform)
      @os_id = os.id

      @requestedAt = payload[:requestedAt]
      @respondedIn = payload[:respondedIn]
      @referredBy = payload[:referredBy]
      @requestType = payload[:requestType]
      @parameters = payload[:parameters]
      @ip = payload[:ip]    
      @resolution = combine_resolutions(
                                        payload[:resolutionWidth], 
                                        payload[:resolutionHeight]
                                        )
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
        UrlPath.find_by_path(path).id
      else
        path = UrlPath.new({:path => urlpath, :site_id => @site_id})
        path.save
        UrlPath.find_by_path(path.path).id
      end
    end

    def find_site_id(urlpath)
      split_url = urlpath.split("/")
      rootUrl = "http://" + split_url[2]
      Site.find_by_rootUrl(rootUrl).id
    end

  end
end
