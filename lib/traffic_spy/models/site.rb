
module TrafficSpy
  class Site
    attr_reader :id, :identifier, :rootUrl

    def initialize(params = {})
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

    def self.find_by_rootUrl(url)
      result = data.first(:rootUrl =>url)
      Site.new(result)
    end

    def self.all
      data.map do |site|
        Site.new(site)
      end
    end

    def exists?
      duplicate = Site.data.where(identifier: identifier).or(rootUrl: rootUrl).to_a
      duplicate.any?
    end

    def valid?
      !identifier.empty? || !rootUrl.empty?
    end

    def save
      return false if !valid?
      Site.data.insert({:identifier => identifier , :rootUrl => rootUrl})
    end

  end
end
