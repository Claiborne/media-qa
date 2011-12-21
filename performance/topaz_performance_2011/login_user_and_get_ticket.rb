require 'rest_client'
require 'json'

uri = "http://secure-stg.ign.com/authentication/login?oauth_token=71339394919e9f00f68b1324179722f1f73c68ef"

(1..3000).each do |name|
  
  body = 
  {
   	"email" => "perftest#{name}a4@hello.com",
   	"provider" => "local",
   	"password" => "testpassword"
  }.to_json

  doc = RestClient.post(uri, body, :Content_Type => 'application/json')
  sleep 0.01
    
  File.open("/Users/wclaiborne/Desktop/user_tickets.txt", "a") do |f|
    ticket = doc.match(/ticket":"[a-z0-9]{23}/).to_s
    f.puts ticket.match(/[a-z0-9]{23}/)
  end

end

