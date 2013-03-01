
module TrafficSpy
  class Site
    attr_reader :id, :identifier, :rootUrl

    def initialize(params)
      @id = params[:id]
      @identifier = params[:identifier]
      @rootUrl = params[:rootUrl]
    end

    def self.data
      DB[:sites]
    end

    def self.count
      data.count
    end

    def self.find(id)
      result = data.first(:id => id)
      Site.new(result)
    end

    def self.exists?(identifier)
      !data.where(:identifier => identifier).empty?
    end

    def self.all
      results = data.map do |site|
        Site.new(site)
      end
    end

    def save
      Site.data.insert({:identifier => identifier , :rootUrl => rootUrl})
    end

  end
end
