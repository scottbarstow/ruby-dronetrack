module Dronetrack
  class RestService
    def initialize (baseUrl, path, accessToken)
      @path = path
      if baseUrl.length > 0 and baseUrl[baseUrl.length - 1] == "/"
            baseUrl = baseUrl[0, baseUrl.length - 1]
      end 
      @client = OAuth2::Client.new("", "", :site => baseUrl) do |conn|
        conn.request :multipart
        conn.request :url_encoded
      end  
      @token = OAuth2::AccessToken.from_hash(client, :access_token => accessToken)
      
    end

    def all (query=nil)
        makeRequest @path, :params => query
    end

    def get (id)
        makeRequest "#{@path}/#{id}"
    end

    def create (item)
        makeRequest @path, :post, {:body => item}
    end

    def update (item)
        makeRequest "#{@path}/#{item.id}", :put, {:body => item}
    end

    def remove (id, callback) 
        makeRequest "#{@path}/#{id}", :delete
    end
    
    alias :destroy :remove    

    protected

    def makeRequest (url, method = :get, opts = {})
        if opts[:headers].nil?
          opts[:headers] = {}
        end  
        opts[:headers]["Accept"] = "application/json"
        if method == :post or method == :put
          opts[:headers]["Content-Type"] = "application/json"
        end  
        res = @token.request(method, url, opts) do |req|
          yield(req) if block_given?
        end
        r = res.parsed
        unless r.error.nil?
          raise r.error
        end  
        r  
    end   


  end
end