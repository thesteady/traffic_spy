#require 'yajl'
require 'json'
require 'user_agent'


module TrafficSpy
  class RequestParser
    attr_accessor :req_attr


    def parse(json_payload)
      payload = JSON.parse(json_payload, :symbolize_names => true)
    end

    def initialize(json_payload)

      payload = parse(json_payload)



      user_agent = UserAgent.parse(payload[:userAgent])

      site_id = find_site_id(payload[:url])
      event = Event.new({name: payload[:eventName], site_id: site_id})
      url = UrlPath.new({path: payload[:url], site_id: site_id})
      os = OperatingSystem.new({name: user_agent.platform})
      browser = Browser.new({name: user_agent.browser})

      req_attr = {}
      req_attr[:site_id] = site_id
      req_attr[:url_path_id] = RequestParser.get_foreign_keys(url)
      req_attr[:event_id] = RequestParser.get_foreign_keys(event)
      req_attr[:browser_id] = RequestParser.get_foreign_keys(browser)
      req_attr[:os_id] = RequestParser.get_foreign_keys(os)
      req_attr[:requested_at] = payload[:requestedAt]
      req_attr[:response_time] = payload[:respondedIn]
      req_attr[:referred_by] = payload[:referredBy]
      req_attr[:request_type] = payload[:requestType]
      req_attr[:ip] = payload[:ip]
      req_attr[:resolution] = combine_resolutions(
                                        payload[:resolutionWidth],
                                        payload[:resolutionHeight]
                                        )


      @req_attr = req_attr

    end

    def create_request

      request = Request.new(@req_attr)
      @req_attr[:id] = request.save
      @req_attr
    end


    def combine_resolutions(width, height)
      "#{width} x #{height}"
    end

    def self.get_foreign_keys(obj)
      obj.find_or_create_and_get_id
    end


    def find_site_id(urlpath)
      split_url = urlpath.split("/")
      rootUrl = "http://" + split_url[2]
      Site.find(rootUrl: rootUrl).id
    end

  end
end
