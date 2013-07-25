module TopazToken

require 'json'
require 'rest_client'

  # FOR PRODUCTION MAKE A POST REQUEST TO THIS URL:
  # http://secure.ign.com/v3/authorization/oauth/token?grant_type=client_credentials&client_id=4e972e6be4b0a23ca6e1f2e6&client_secret=abc123

  # SCOPE: ["authorization-config","playlists","read","authentication-user","articles","canSeeAll","authorization-client","entitlements-config","promotions","authentication-login","entitlements-set","authentication-ticket","videos","objects","images","write","social-ratings","redirect"]

  def self.initial
    file = File.new(File.dirname(__FILE__) + "/../config/topaz_token.txt", "r")
    @token = file.gets.to_s
    file.close
  end

  @token = TopazToken.initial

  def self.set_token(scope)

    client_id = '4e972e6be4b0a23ca6e1f2e6'
    client_secret = 'abc123'

    PathConfig.config_path = File.dirname(__FILE__) + "/../config/topaz_api.yml"
    @config = PathConfig.new

    begin
      RestClient.get "http://#{@config.options['baseurl']}/v3/authorization/oauth/valid?access_token=#{@token}&scope=#{scope}"
    rescue
      token_response = RestClient.post "http://#{@config.options['baseurl']}/v3/authorization/oauth/token?grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}", ""
      token = JSON.parse(token_response.body)
      @token = token['access_token']
      File.open(File.dirname(__FILE__) + "/../config/topaz_token.txt", 'w') {|f| f.write(@token)}
    end
  end
  
end

