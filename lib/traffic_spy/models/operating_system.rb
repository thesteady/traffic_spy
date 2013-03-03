module TrafficSpy
  class OperatingSystem

    attr_reader :id, :name

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
    end

    def self.data
      DB[:operating_systems]
    end

    def self.count
      data.count
    end

    def self.find(input)
      data.where(input).map do |result|
        OperatingSystem.new(result)
      end.first
    end

    def exists?
      duplicate = OperatingSystem.data.where(name: name).to_a
      duplicate.any?
    end

    def self.all
      results = data.map do |os|
        OperatingSystem.new(os)
      end
    end

    def save
      OperatingSystem.data.insert({:name => name})
    end

  end
end
