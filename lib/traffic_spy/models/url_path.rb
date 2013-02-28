module TrafficSpy
  class UrlPath
  
  attr_reader :url_path
  
    def initialize(params)
      @url_path = params[:url]
    end

  end
end
