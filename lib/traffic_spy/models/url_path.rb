module TrafficSpy
  class UrlPath

  attr_reader :id, :path

    def initialize(params)
      @id = params[:id]
      @path = params[:path]
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

    def self.exists?(path)
      !data.where(:path => path).empty?
    end

    def self.all
      results = data.map do |path|
        UrlPath.new(path)
      end
    end

    def save
      UrlPath.data.insert({:path => path})
    end

    #def self.parse(url_path)
      #based on teh url path, spit back a primary key id
    #end
  end
end
