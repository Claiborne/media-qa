require 'rest-client'
require 'rest_client'
require 'json'

uri = "http://secure-stg.ign.com/authentication/user/register?oauth_token=71339394919e9f00f68b1324179722f1f73c68ef"

(61..80).each do |name|
  
  emailname = "perftest_#{name}@hello.com"
  
  body = 
  {
   	"email" => emailname,
   	"provider" => "google",
   	"password" => "testpassword"
    }.to_json

    doc = RestClient.post(uri, body, :Content_Type => 'application/json')
    
  File.open("/Users/wclaiborne/Desktop/users.txt", "a") do |f|
    f.puts emailname
    f.puts doc.match(/[a-z0-9]{24}/)
    f.puts ""
  end

end

