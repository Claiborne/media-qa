require 'test/unit'
require 'rubygems'
require 'json'
require 'net/http'

class Testthis < Test::Unit::TestCase

  def test_testthis
  

	http = Net::HTTP.new("fedreg-api.ign.com")

	request = Net::HTTP::Post.new("/3.0/FedRegService.svc/users/json", {'Content-Type' => 'application/json'} )

	request.body = 
	{
	"AppKey" => "www.ign.com", 
	"Email" => "elwia4wdan@elwdawwin.com", 
	"Password" => "elwinaw4d2w34",
	"Nickname" => "elw3244rs3bomb"
	}.to_json

	response = http.request(request)

	puts response.body

  end
end
	