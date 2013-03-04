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

    def self.find(id)
      result = data.first(:id => id)
      UrlPath.new(result)
    end

    def self.find_by_path(url)
     result = data.first(:path =>url)
      UrlPath.new(result)
    end

    def self.find_all_by_site_id(site_id)
      data.where(:site_id => site_id).to_a
    end

    def self.exists?(url)
      !data.where(:path => url).empty?
    end

    def self.all
      results = data.map do |path|
        UrlPath.new(path)
      end
    end

    def save
      #create a method here to check if path already exists in db
      #if exists, dont save and assign proper ids
      #else, create new
      UrlPath.data.insert({:path => path, :site_id => site_id})
    end

  end
end
