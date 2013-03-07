module TrafficSpy

  class SiteSummary

    #attr_reader :url_results

    def initialize(site)
      @site = site
    end

    def url_results
      @url_results ||= Request.summarize_url_requests_for_site(@site.id).inject({}) do |hash, url|
        path = UrlPath.find({id: url[:url_path_id]}).path
        hash[path] = url[:count]
        hash
      end.sort_by{|k, v| v}.reverse
    end

    def browser_results
      @browser_results ||= Request.summarize_browser_requests_for_site(@site.id).inject({}) do |hash, browser|
        name = Browser.find({id: browser[:browser_id]}).name
        hash[name] = browser[:count]
        hash
      end.sort_by{|k, v| v}.reverse
    end

    def os_results
      @os_results ||= Request.summarize_os_requests_for_site(@site.id).inject({}) do |hash, os|
        name = OperatingSystem.find({id: os[:os_id]}).name
        hash[name] = os[:count]
        hash
      end.sort_by{|k, v| v}.reverse
    end

    def res_results
      @res_results ||= Request.summarize_res_requests_for_site(@site.id).inject({}) do |hash, res|
        hash[res[:resolution]] = res[:count]
        hash
      end.sort_by{|k, v| v}.reverse
    end

    def response_times
      @response_times ||= Request.summarize_response_times_for_site(@site.id).inject({}) do |hash, (k, v)|
        path = UrlPath.find({id: k}).path
        hash[path] = v
        hash
      end.sort_by{|k, v| v}.reverse
    end

    def event_results
      @event_results ||= Request.summarize_event_requests_for_site(@site.id).inject({}) do |hash, event|
        name = Event.find({id: event[:event_id]},{}).name
        hash[name] = event[:count]
        hash
      end.sort_by{|k, v| v}.reverse
    end

  end
end
