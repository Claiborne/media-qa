module TopazToken

require 'json'
require 'rest_client'

  def return_topaz_token(scope)
    client_id = '4e972e6be4b0a23ca6e1f2e6'
    client_secret = 'abc123'

    file = File.new(File.dirname(__FILE__) + "/../config/topaz_token.txt", "r")
    token = file.gets.to_s
    file.close

    begin
      RestClient.get "http://secure-stg.ign.com/v3/authorization/oauth/valid?access_token=#{token}&scope=#{scope}"
    rescue
      token_response = RestClient.post "http://secure-stg.ign.com/v3/authorization/oauth/token?grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}", ""
      token = JSON.parse(token_response.body)
      token = token['access_token']
      File.open(File.dirname(__FILE__) + "/../config/topaz_token.txt", 'w') {|f| f.write(token)}
    end
    
    token

  end

end