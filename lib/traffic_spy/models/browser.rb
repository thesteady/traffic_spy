module TrafficSpy
  class Browser

  attr_reader :id, :name

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
    end

    def self.data
      DB[:browsers]
    end

    def self.count
      data.count
    end

    def self.find(id)
      result = data.first(:id => id)
      Browser.new(result)
    end

    def self.find_by_name(b_name)
      result = data.first(:name =>b_name)
      Browser.new(result)
    end

    def self.exists?(b_name)
      !data.where(:name => b_name).empty?
    end

    def self.all
      results = data.map do |browser|
        Browser.new(browser)
      end
    end

    def save
      Browser.data.insert({:name => name})
    end

  end
end

