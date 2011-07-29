require 'net/http'
require 'rubygems'
require 'json'

user_id = "1938462" 
status = "Status"

http = Net::HTTP.new("social-stg-services.ign.com")

request = Net::HTTP::Post.new("/v1.0/social/rest/status/#{1938462}/@self?st=#{1938462}:#{1938462}:0:ign.com:my.ign.com:0:0", {'Content-Type' =>'application/json'} )

request.body = 
{"status" => status
}.to_json

response = http.request(request)

puts response.body


