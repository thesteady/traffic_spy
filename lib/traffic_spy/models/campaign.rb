module TrafficSpy
  class Campaign

    attr_reader :id, :name

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
    end

    def self.data
      DB[:campaigns]
    end

    def self.count
      data.count
    end

    def self.find(id)
      result = data.first(:id => id)
      Campaign.new(result)
    end

    def self.find_by_name(c_name)
      result = data.first(:name =>c_name)
      Campaign.new(result)
    end

    def self.exists?(c_name)
      !data.where(:name => c_name).empty?
    end

    def self.all
      results = data.map do |campaign|
        Campaign.new(campaign)
      end
    end

    def save
      Campaign.data.insert({:name => name})
    end

  end
end
