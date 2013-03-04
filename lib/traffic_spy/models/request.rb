require 'json'

module TrafficSpy
  class Request

    attr_reader :id, :event_id, :url_path_id, :browser_id, :os_id, :site_id,
                :requested_at, :response_time, :referred_by, :request_type,
                :resolution, :ip

    def initialize(input)
      @id = input[:id]
      @url_path_id = input[:url_path_id]
      @event_id = input[:event_id]
      @browser_id = input[:browser_id]
      @os_id = input[:os_id]
      @site_id = input[:site_id]
      @requested_at = input[:requested_at]
      @response_time = input[:responded_at]
      @referred_by = input[:referred_by]
      @request_type = input[:request_type]
      @resolution = input[:resolution]
      @ip = input[:ip]
    end

    def save
      Request.data.insert({ site_id: site_id, url_path_id: url_path_id , event_id: event_id,
                            browser_id: browser_id, os_id: os_id,
                            site_id: site_id, requested_at: requested_at,
                            response_time: response_time,
                            referred_by: referred_by, request_type: request_type,
                            resolution: resolution, ip: ip})
    end

    def self.data
      DB[:requests]
    end

    def self.count
      data.count
    end

    def self.all
      data.map do |request|
        Request.new(request)
      end
    end

    def self.find(input)
      data.where(input).map do |result|
        Request.new(result)
      end
    end

    def self.summarize_url_requests_for_site(site_id)
      data.group_and_count(:url_path_id).where(:site_id =>site_id).to_a
      #returns a hash with id1=>count, id2=>count
    end

    def self.summarize_browser_requests_for_site(site_id)
      data.group_and_count(:browser_id).where(:site_id =>site_id).to_a
    end

    def self.summarize_os_requests_for_site(site_id)
      data.group_and_count(:os_id).where(:site_id =>site_id).to_a
    end

    def self.summarize_res_requests_for_site(site_id)
      data.group_and_count(:resolution).where(:site_id =>site_id).to_a
    end

  end
end

# should this look like?
# @path = RequestParser.path
# @resolution = RequestParser.resolution
