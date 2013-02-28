module TrafficSpy
  class Event
  attr_reader :name
    def initialize(params)
    @name = params[:eventname]
    end
  end
end
