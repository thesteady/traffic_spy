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

    def self.find_all_by_site_id(site_id)
      data.where(:site_id => site_id).to_a
    end

    def self.find(input1, input2)
      # need to add site_id to search as well
      data.where(input1).where(input2).map do |result|
        Event.new(result)
      end.first
    end

    def exists?
      # need to add site_id to search as well .where(site_id: site_id)
      duplicate = Event.data.where(name: name).where(site_id: site_id).to_a
      duplicate.any?
    end

    def self.all
      results = data.map do |event|
        Event.new(event)
      end
    end

    def find_id
      result = Event.data.where(name: name).where(site_id: site_id).to_a
      result.empty? ? false : result.first[:id]
    end

    def find_or_create_and_get_id
      find_id || save
    end

    def event_dates
      # query results table with event_id and extract array of dates
    end

    def save
      Event.data.insert({:name => name, :site_id => site_id})
    end
  end
end
