
module TrafficSpy
  class Site
    attr_reader :identifier, :rootUrl

    def initialize(params)
      @identifier = params[:identifier]
      @rootUrl = params[:rootUrl]
    end

  end
end
