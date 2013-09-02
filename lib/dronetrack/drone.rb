module Dronetrack
  class Drone < RestService
    def initialize (baseUrl, accessToken)
        super(baseUrl, "/drone", accessToken)
    end

    def add_points (id, trackId, points=[])
        if trackId.is_a? Array or trackId.is_a? Hash
          points = trackId
          trackId = nil
        end
        makeRequest "#{@path}/#{id}/points", :post, {:body => {:trackId => trackId, :points => points}.to_json, :headers=>{'Content-Type' => 'application/json'}}
    end    

    def import_points_from_files (id, files, format=:csv)
        f = format.to_s().upcase()
        raise ArgumentError, "Format #{f} is not supported" if f != "CSV" && f != "KML"
        body = {}
        i = 1
        mime = "application/vnd.google-earth.kml+xml"
        mime = "text/csv" if format == :csv
        files.each do |file|
          body["file#{i}".to_sym] = Faraday::UploadIO.new(file, mime)
          i = i + 1
        end
        r = createNewRequest do |con|
          con.request :multipart
          con.request :url_encoded
          con.adapter :net_http
        end
        r.post "#{@path}/#{id}/import#{f}", {:body => body, :headers => {"Accept" => "application/json"}}
    end
    
  end
end