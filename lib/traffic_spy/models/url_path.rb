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

    def self.exists?(path)
      !data.where(:path => path).empty?
    end

    def self.all
      results = data.map do |path|
        UrlPath.new(path)
      end
    end

    def save
      UrlPath.data.insert({:path => path, :site_id => site_id})
    end

    #def self.parse(url_path)
      #based on the url path, spit back a primary key id
    #end
  end
end
