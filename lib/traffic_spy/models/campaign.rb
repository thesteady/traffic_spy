module TrafficSpy
  class Campaign

    attr_accessor :id, :name, :site_id

    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @site_id = input[:site_id]
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

    def self.find_all_by(site_id)
      data.where(site_id: site_id).to_a
    end

    def self.all
      results = data.map do |campaign|
        Campaign.new(campaign)
      end
    end

    def exists?
      duplicate = Campaign.data.where(name: name).to_a
      duplicate.any?
    end

    def save
      Campaign.data.insert({:name => name, :site_id =>site_id})
    end

    def missing_name?
      name.nil? || name.empty?
    end

  end
end
