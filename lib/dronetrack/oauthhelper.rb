module Dronetrack
  class OAuthHelper
    def initialize (baseUrl, clientId, clientSecret, redirectUrl)
        @client = OAuth2::Client.new(clientId, clientSecret, {:site => baseUrl, :authorize_url => "#{@baseUrl}/auth/dialog", :token_url => "#{@baseUrl}/auth/token"})
        @redirectUrl = redirectUrl
    end

    def getAccessToken (getCode, &block)
        url = @client.auth_code.authorize_url(:redirect_uri => @redirectUrl)
        b = if block_given? then block else Proc.new() end
        complete = Proc.new do |code| 
            token = @client.auth_code.get_token(code, :redirect_uri => @redirectUrl)
            b.call token.token
        end
        
        getCode.call url, complete
    end    
  end
end