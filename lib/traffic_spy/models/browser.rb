module TrafficSpy
  class Browser
  
  attr_reader :browser
  
    def initialize(params)
      @browser = params[:browser]
    end

  end
end


#Hash
#"userAgent":"Mozilla/5.0 
#(Macintosh; Intel Mac OS X 10_8_2) 
#AppleWebKit/537.17 (KHTML, like Gecko) 
#Chrome/24.0.1309.0
#Safari/537.17"
#"userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"

#userAgent_pieces = payload["userAgent"].split
#web_browser = userAgent_pieces[0]
