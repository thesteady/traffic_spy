module TrafficSpy
  class Campaign

    attr_accessor :id, :name, :site_id

    def initialize(input)
      #site_id = Site.find(identifier: input[:identifier]).id

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

    def self.all
      results = data.map do |campaign|
        Campaign.new(campaign)
      end
    end

    def exists?
      duplicate = Campaign.data.where(name: name).to_a
      duplicate.any?
    end

    # def self.campaign_for_site_exists?
    #   duplicate = Campaign.data.where(site_id: site_id).to_a
    #   duplicate.any?
    # end

    def save
      Campaign.data.insert({:name => name, :site_id =>site_id})
    end

    def missing_name?
      name.nil? || name.empty?
    end

  end
end
