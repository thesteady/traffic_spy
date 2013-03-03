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

    def self.find(id)
      result = data.first(:id => id)
      Event.new(result)
    end

    def self.find_all_by_site_id(site_id)
      events = data.where(:site_id => site_id).to_a
    end

    def self.find_by_eventName(eventName)
      result = data.first(:name => eventName)
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
      Event.data.insert({:name => name, :site_id => site_id})
    end
  end
end
