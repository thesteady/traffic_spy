require 'json'
#takes in all data, parses, and spits it to the classes.

#where do we check for duplicates in things likes url paths, etc?
module TrafficSpy
  class RequestParser
    attr_accessor :url
    attr_reader :requestedAt, :respondedIn, :referredBy, :requestType,
                :parameters, :eventName, :userAgent, 
                :resolution
                :ip

    def parse(json_payload)
      payload = JSON.parse(json_payload)
    end

      
    def initialize(json_payload)
      payload = parse(json_payload)

      # url_path_id = TrafficSpy::UrlPath.parse(payload["url"])
      # @url = url_path_id
      @url = payload["url"]

      @requestedAt = payload["requestedAt"]
      @respondedIn = payload["respondedIn"]
      @referredBy = payload["referredBy"]
      @requestType = payload["requestType"]
      @parameters = payload["parameters"]

      @eventName = payload["eventName"]
      
      @userAgent = payload["userAgent"]
      
      @resolution = combine_resolutions(
                                        payload["resolutionWidth"], 
                                        payload["resolutionHeight"]
                                        )
      @ip = payload["ip"]
    
    end

    def combine_resolutions(width, height)
      "#{width} x #{height}"
    end

  end
end
