module Dronetrack
  class Track < RestService
    def initialize (baseUrl, accessToken)
        super(baseUrl, "/track", accessToken)
    end

    def getPoints (id, callback)
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
        for file in files
            body["file#{i}"] = UploadIO.new(file, mime)
            i = i + 1
        end    
        makeRequest "#{@path}/#{id}/points/import#{f}", :post, {:body => body}
    end    
  end
end