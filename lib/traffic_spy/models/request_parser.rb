require 'json'

module TrafficSpy
  class RequestParser
    attr_accessor :path_id
    attr_reader :requestedAt, :respondedIn, :referredBy, :requestType,
                :parameters, :eventName, :userAgent, 
                :resolution
                :ip

    def parse(json_payload)
      payload = JSON.parse(json_payload)
      #returns a hash with the format {"url"=>"link", "next"=>"value", etc}
      #below changes keys to symbols for easy use elsewhere
      Hash[payload.map{|(k,v)| [k.to_sym,v]}]
    end
      
    def initialize(json_payload)
      payload = parse(json_payload)

      if UrlPath.exists?(payload[:url])
        puts "path exists"
        urlpath = UrlPath.find_by_path(path)
        urlpath.id
      else
        path = UrlPath.new({:path => payload[:url], :site_id => 1})
        path.save
        urlpath = UrlPath.find_by_path(path.path)
        @path_id = urlpath.id
      end
    
      @requestedAt = payload[:requestedAt]
      @respondedIn = payload[:respondedIn]
      @referredBy = payload[:referredBy]
      @requestType = payload[:requestType]
      @parameters = payload[:parameters]

      @eventName = payload[:eventName]
      
      @userAgent = payload[:userAgent]
      
      @resolution = combine_resolutions(
                                        payload[:resolutionWidth], 
                                        payload[:resolutionHeight]
                                        )
      @ip = payload[:ip]
    
    end

    def combine_resolutions(width, height)
      "#{width} x #{height}"
    end

    # def parse_urlpath(urlpath)
    # end


  end
end
