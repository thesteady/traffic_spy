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

    def self.find(input)
      data.where(input).map do |result|
        Browser.new(result)
      end.first
    end

    def self.find_by_name(b_name)
      result = data.first(:name =>b_name)
      Browser.new(result)
    end

    def exists?
      duplicate = Browser.data.where(name: name).to_a
      duplicate.any?
    end

    def self.all
      results = data.map do |browser|
        Browser.new(browser)
      end
    end

    def save
      Browser.data.insert({:name => name})
    end

    def find_id
      result = Browser.data.where(name: name).to_a
      result.empty? ? false : result.first[:id]
    end

    def find_or_create_and_get_id
      find_id || save
    end

  end
end

