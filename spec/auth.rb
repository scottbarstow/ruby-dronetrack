require 'phantomjs.rb'

$accessToken = nil

def getAccessToken
  helper = OAuthHelper.new $config['baseUrl'], $config['clientId'], $config['clientSecret'], 'http://localhost'
  get_code = lambda do |url, done|
    code = Phantomjs.run(File.expand_path('../auth.js', __FILE__), "\"#{$config['baseUrl']}\"", "\"#{url}\"", $config['userName'], $config['password'])
    code = '' if code.nil?
    code.strip!
    done.call(code)
  end

  helper.getAccessToken get_code do |token|
    raise "Invalid access token #{token}" if not token.is_a?(String) or token.length == 0
    yield(token) if block_given?
  end
end

def authorize
  if $accessToken.nil?
    getAccessToken do |token|
      $accessToken = token
      yield(token) if block_given?
    end
  else
    yield($accessToken) if block_given?
  end
end