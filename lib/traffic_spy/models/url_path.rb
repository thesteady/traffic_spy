module TrafficSpy
  class UrlPath

  attr_reader :id, :path, :site_id

    def initialize(input)

      @id = input[:id]
      @path = input[:path]
      @site_id = input[:site_id]
    end

    def self.data
      DB[:url_paths]
    end

    def self.count
      data.count
    end

    def self.find(input)
      data.where(input).map do |result|
        UrlPath.new(result)
      end.first
    end

    def exists?
      duplicate = UrlPath.data.where(path: path).to_a
      duplicate.any?
    end

    def self.all
      results = data.map do |path|
        UrlPath.new(path)
      end
    end

    def save
      UrlPath.data.insert({path: path, site_id: site_id})
    end

    def find_id
      result = UrlPath.data.where(path: path).to_a
      result.empty? ? false : result.first[:id]
    end

    def find_or_create_new_and_return_id
      find_id || save
    end


  end
end
