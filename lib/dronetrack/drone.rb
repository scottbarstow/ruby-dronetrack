module Dronetrack
  class Drone < RestService
    def initialize (baseUrl, accessToken)
        super(baseUrl, "/drone", accessToken)
    end

    def addPoints (id, trackId=nil, points=[])
        makeRequest "#{@path}/#{id}/points", :post, :body => {:trackId => trackId, :points => points}
    end    

    def importPointsFromFiles (id, files, format=:csv)
        f = format.to_s().upcase()
        raise "Format #{f} is not supported" if f != "CSV" && f != "KML"
        body = {}
        i = 1
        mime = "application/vnd.google-earth.kml+xml"
        mime = "text/csv" if format == :csv
        for file in files
            body["file#{i}"] = UploadIO.new(file, mime)
            i = i + 1
        end    
        makeRequest "#{@path}/#{id}/import#{f}", :post, {:body => body}
    end    
    
  end
end