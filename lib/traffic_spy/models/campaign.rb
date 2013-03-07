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
        new = Campaign.new(result)
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

    def self.get_site_campaign_names(site_id)
        array_of_hashes = data.where(site_id: site_id).to_a
        names = []
        array_of_hashes.each do |campaign|
          names << campaign[:name]
        end
        names
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

    def self.get_campaign_id(input)
      data.where(site_id: input[:site_id]).where(name: input[:name]).to_a
    end

    def events
    #I want a hash of eventnames and count for this site id
    # {sociallogin: 3, click: 4}

    end

    # def event_results
    #   @event_results ||= Request.summarize_event_requests_for_site(@site.id).inject({}) do |hash, event|
    #     name = Event.find({id: event[:event_id]},{}).name
    #     hash[name] = event[:count]
    #     hash
    #   end.sort_by{|k, v| v}.reverse
    # end

  end
end
