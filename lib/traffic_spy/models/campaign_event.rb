module TrafficSpy
  class CampaignEvent

  attr_reader :id, :campaign_id, :event_id

    def initialize(input)
      @id = input[:id]
      @campaign_id = input[:campaign_id]
      @event_id = input[:event_id]
    end

    def self.data
      DB[:campaign_events]
    end

    def self.count
      data.count
    end

    def self.find_all(input)
      data.where(input).map do |result|
        CampaignEvent.new(result)
      end
    end

    def self.all
      data.map do |campaign_event|
        CampaignEvent.new(campaign_event)
      end
    end

    def save
      CampaignEvent.data.insert(campaign_id: campaign_id, event_id: event_id)
    end

  end
end

