require 'rest_client'
require 'json'

uri = "https://secure.ign.com/authentication/user/register?oauth_token=ea8e68350192bb52ebf88ec7dc7519c92b8cd6e5"
social_uri = "http://social-services.ign.com/v1.0/social/rest/reg"

(0..150).each do |name|
  
  emailname = "sf_testuser#{name}@hello.com"
  
  body = 
  {
   	"email" => emailname,
   	"provider" => "local",
   	"password" => "testpassword"
    }.to_json
    
  doc = RestClient.post(uri, body, :Content_Type => 'application/json')
    
  social_body = 
  {
    "email" => emailname,
    "nickname" => emailname.match(/\A[a-z0-9_]*/).to_s,
    "accounts" => [ {"accountType" => "topaz","key1" => doc.match(/[a-z0-9]{24}/).to_s,"key2" => "local"} ]
  }.to_json

  s_soc = RestClient.post(social_uri, social_body, :Content_Type => 'application/json')
    
  File.open("/Users/wclaiborne/Desktop/users.txt", "a") do |f|
    f.puts emailname
    f.puts doc.match(/[a-z0-9]{24}/)
    f.puts ""
  end

end#end iteration

# ID 4e972e6be4b0a23ca6e1f2e6
# TOKEN ea8e68350192bb52ebf88ec7dc7519c92b8cd6e5