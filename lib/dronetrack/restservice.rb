require 'oauth2'
require 'json'
module Dronetrack
  class RestService
    def initialize (baseUrl, path, accessToken)
      @path = path
      if baseUrl.length > 0 and baseUrl[baseUrl.length - 1] == "/"
            baseUrl = baseUrl[0, baseUrl.length - 1]
      end 
      @baseUrl = baseUrl
      @accessToken = accessToken
      @client = OAuth2::Client.new("", "", :site => baseUrl)
      @token = OAuth2::AccessToken.from_hash(@client, :access_token => accessToken)
    end

    def all (query=nil)
        opts = if query.nil? then {} else {:params => query} end
        makeRequest @path, :get, opts
    end

    def get (id)
        makeRequest "#{@path}/#{id}", :get
    end

    def create (item)
        makeRequest @path, :post, {:body => item}
    end

    def update (item)
        makeRequest "#{@path}/#{item['id']}", :put, {:body => item}
    end

    def remove (id)
        makeRequest "#{@path}/#{id}", :delete
    end
    
    alias :destroy :remove    

    protected

    def makeRequest (url, method, opts = {}, &block)
        if opts[:headers].nil?
          opts[:headers] = {}
        end  
        opts[:headers]["Accept"] = "application/json"
        res = @token.request(method, url, opts, &block)
        r = res.parsed
        if r.kind_of?(Hash) and r.has_key?(:error)
          raise StandardError, r[:error]
        end  
        r  
    end

    def createNewRequest (&block)
      client = OAuth2::Client.new("", "", :site => @baseUrl) do |conn|
          yield(conn) if block_given?
      end
      OAuth2::AccessToken.from_hash(client, :access_token => @accessToken)
    end


  end
end