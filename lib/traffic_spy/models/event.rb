module TrafficSpy
  class Event

    attr_reader :id, :name, :site_id

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @site_id = params[:site_id]
    end

    def self.data
      DB[:events]
    end

    def self.count
      data.count
    end

    def self.find(input)
      data.where(input).map do |result|
        Event.new(result)
      end.first
    end

    def exists?
      duplicate = Event.data.where(name: name).to_a
      duplicate.any?
    end

    def self.all
      results = data.map do |event|
        Event.new(event)
      end
    end

    def find_id
      result = Event.data.where(name: name).to_a
      result.empty? ? false : result.first[:id]
    end

    def find_or_create_and_get_id
      find_id || save
    end

    def save
      Event.data.insert({name: name})
    end
  end
end
