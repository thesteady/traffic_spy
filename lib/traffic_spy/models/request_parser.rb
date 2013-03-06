#require 'yajl'
require 'json'
require 'user_agent'


module TrafficSpy
  class RequestParser
    attr_accessor :req_attributes
    attr_reader :site_id, :payload

    def initialize(json_payload)
      @payload = parse(json_payload)
      @site_id = find_site_id(payload[:url])

      @req_attributes = default_hash_for_payload(payload).update(
        site_id: site_id,
        event_id: event_id,
        url_path_id: url_id,
        os_id: os_id,
        browser_id: browser_id
      )
    end

    def create_request
      request = Request.new(@req_attributes)
      @req_attributes[:id] = request.save
      @req_attributes

    end

    def default_hash_for_payload(payload)
      {
        requested_at: payload[:requestedAt],
        response_time: payload[:respondedIn],
        referred_by: payload[:referredBy],
        request_type: payload[:requestType],
        ip: payload[:ip],
        resolution: combine_resolutions(payload)
      }
    end

    def parse(json_payload)
      payload = JSON.parse(json_payload, :symbolize_names => true)
    end

    def parse_user_agent
      ua = UserAgent.parse(payload[:userAgent])

      user_agent = {}
      user_agent[:os] = OperatingSystem.new({name: ua.platform})
      user_agent[:browser] = Browser.new({name: ua.browser})
      user_agent
    end

    def event_id
      RequestParser.get_foreign_keys(Event.new({name: payload[:eventName], site_id: site_id}))
    end

    def url_id
      RequestParser.get_foreign_keys(UrlPath.new({path: payload[:url], site_id: site_id}))
    end

    def browser_id
      RequestParser.get_foreign_keys(parse_user_agent[:browser])
    end

    def os_id
      RequestParser.get_foreign_keys(parse_user_agent[:os])
    end

    def combine_resolutions(payload)
      "#{payload[:resolutionWidth]} x #{payload[:resolutionHeight]}"
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
