module TrafficSpy
  class OperatingSystem

  attr_reader :operating_system

    def initialize(params)
      @operating_system = params[:os]
    end

  end
end
