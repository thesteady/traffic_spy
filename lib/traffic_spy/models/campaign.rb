module TrafficSpy
  class Campaign

    attr_reader :name

    def initialize(params)
      @name = params[:campaign_name]
    end
  
  end
end
