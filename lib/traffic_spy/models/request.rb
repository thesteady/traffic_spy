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
      Request.data.insert({ :url_path_id => url_path_id , :event_id => event_id,
                            :browser_id => browser_id, :os_id => os_id,
                            :site_id => site_id, :requested_at => requested_at,
                            :response_time => response_time,
                            :referred_by => referred_by, :request_type => request_type,
                            :resolution => resolution, :ip => ip})
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

    def self.find_by_id(id)
      result = data.first(:id => id)
      Request.new(result)
    end

    def self.find_by_site_id(s_id)
      data.where(:site_id => s_id).map do |req|
        Request.new(req)
      end
    end

    def self.find_by_event_id(e_id)
      data.where(:event_id => e_id).map do |req|
        Request.new(req)
      end
    end

    def self.find_by_url_path_id(u_id)
      data.where(:url_path_id => u_id).map do |req|
        Request.new(req)
      end
    end

    def self.find_by_browser_id(b_id)
      data.where(:browser_id => b_id).map do |req|
        Request.new(req)
      end
    end

    def self.find_by_os_id(o_id)
      data.where(:os_id => o_id).map do |req|
        Request.new(req)
      end
    end

    def self.find_by_resolution(res)
      data.where(:resolution => res).map do |req|
        Request.new(req)
      end
    end

    # def exists?(input)
    #   data.where(:event_id => input[:event_id], :)
    # end


  end
end

# should this look like?
# @path = RequestParser.path
# @resolution = RequestParser.resolution
