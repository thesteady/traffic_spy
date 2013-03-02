require 'json'

module TrafficSpy
  class RequestParser
    attr_accessor :path_id
    attr_reader :requestedAt, :respondedIn, :referredBy, :requestType,
                :parameters, :eventName, :userAgent, 
                :resolution,
                :ip

    def parse(json_payload)
      payload = JSON.parse(json_payload)
      #returns a hash with the format {"url"=>"link", "next"=>"value", etc}
      #below changes keys to symbols for easy use elsewhere
      Hash[payload.map{|(k,v)| [k.to_sym,v]}]
    end
      
    def initialize(json_payload)
      payload = parse(json_payload)
      

      @path_id = parse_urlpath(payload[:url])
    
      @eventName = payload[:eventName]
      @userAgent = payload[:userAgent]

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

    def parse_urlpath(urlpath)
      if UrlPath.exists?(urlpath)
        UrlPath.find_by_path(path).id
      else

        split_url = urlpath.split("/")
        rootUrl = "http://" + split_url[2]
        site_id = Site.find_by_rootUrl(rootUrl).id

        path = UrlPath.new({:path => urlpath, :site_id => site_id})
        path.save
        UrlPath.find_by_path(path.path).id
      end
    end


  end
end
