module Dronetrack
  class Track < RestService
    def initialize (baseUrl, accessToken)
        super(baseUrl, "/track", accessToken)
    end

    def getPoints (id)
        makeRequest "#{@path}/#{id}/points", :get
    end    

    def addPoints (id, points=[])
        makeRequest "#{@path}/#{id}/points", :post, {:body => points.to_json, :headers=>{'Content-Type' => 'application/json'}}
    end    

    def importPointsFromFiles (id, files, format=:csv)
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
        r.post "#{@path}/#{id}/points/import#{f}", {:body => body, :headers => {"Accept" => "application/json"}}
    end
  end
end