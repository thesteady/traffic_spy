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

    def self.find(input)
      data.where(input).map do |result|
        Campaign.new(result)
      end.first
    end

    def exists?
      duplicate = Campaign.data.where(name: name).to_a
      duplicate.any?
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
