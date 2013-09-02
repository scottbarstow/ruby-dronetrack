require 'phantomjs.rb'

def getAccessToken
  helper = OAuthHelper.new $config['baseUrl'], $config['clientId'], $config['clientSecret'], 'http://localhost'
  get_code = lambda do |url, done|
    done.call(Phantomjs.run(File.expand_path('../auth.js', __FILE__), $config['baseUrl'], url, $config['userName'], $config['password']))
  end

  helper.getAccessToken get_code do |token|
    raise "Invalid access token #{token}" if not token.is_a?(String) or token.length == 0
    yield(token) if block_given?
  end

end