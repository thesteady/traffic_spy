module TrafficSpy
  class UrlPath
  
  attr_reader :url_path
  
    def initialize(params)
      @url_path = params[:url]
    end

    #def self.parse(url_path)
      #based on teh url path, spit back a primary key id
    #end
  end
end
