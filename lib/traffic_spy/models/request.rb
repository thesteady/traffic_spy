require 'json'

module TrafficSpy
  class Request
    attr_reader :url, :requestedAt, :respondedIn

    def initialize(params)
      
      @url = params["url"]

      @requestedAt = params["requestedAt"]
      @respondedIn = params["respondedIn"]
      @referredBy = params["referredBy"]
      @requestType = params["requestType"]
      @parameters = params["parameters"]
      @eventName = params["eventName"]
      @userAgent = params["userAgent"]
      @resolutionWidth = params["resolutionWidth"]
      @resolutionHeight = params["resolutionHeight"]
      @ip = params["ip"]
    end
  
  end
end

# should this look like?
# @url = RequestParser.url
# @resolution = RequestParser.resolution
