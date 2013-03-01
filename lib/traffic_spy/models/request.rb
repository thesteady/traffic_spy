require 'json'

module TrafficSpy
  class Request
    attr_reader :url, :requestedAt, :respondedIn

    def parse_json(params)
      JSON.parse(params)
    end

    def initialize(json_payload)
      payload = parse_json(json_payload)

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
      @resolutionWidth = payload["resolutionWidth"]
      @resolutionHeight = payload["resolutionHeight"]
      @ip = payload["ip"]
    end

  end
end
