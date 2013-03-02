module TrafficSpy
  class Event

    attr_reader :id, :name

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
    end


    def self.data
      DB[:events]
    end

    def self.count
      data.count
    end

    def self.find(id)
      result = data.first(:id => id)
      Event.new(result)
    end

    def self.exists?(name)
      !data.where(:name => name).empty?
    end

    def self.all
      results = data.map do |event|
        Event.new(event)
      end
    end

    def save
      Event.data.insert({:name => name})
    end
  end
end
