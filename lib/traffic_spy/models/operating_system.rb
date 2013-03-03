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

    def self.find(id)
      result = data.first(:id => id)
      OperatingSystem.new(result)
    end

    def self.find_by_name(os_name)
      result = data.first(:name =>os_name)
      OperatingSystem.new(result)
    end

    def self.exists?(os_name)
      !data.where(:name => os_name).empty?
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
