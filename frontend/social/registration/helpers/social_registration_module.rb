module SocialRegistrationModule

  def register_post
	http = Net::HTTP.new("fedreg-api.ign.com")

	request = Net::HTTP::Post.new("/3.0/FedRegService.svc/users/json", {'Content-Type' => 'application/json'} )
	
	# SETUP PARAM VALS FOR JSON REQ BODY
	
	email_val = "hello"+(rand(10000000)+100).to_s+"@hello.com"
	password_val = (rand(10000000)+10000).to_s
	username_val = "a"+(rand(10000000)+100).to_s
	
	
	request.body = 
	{
	"AppKey" => "www.ign.com", 
	"Email" => email_val, 
	"Password" => password_val,
	"Nickname" => username_val
	}.to_json

	response = http.request(request)
	
	puts "*********RESPONSE BODY START*********"
	puts response.body
	puts "**********RESPONSE BODY END**********"
	
	resp_body = response.body.to_s
	
	# ASSERT BODY RESPONSE RETURNS "OK"
	begin
        assert /ErrorMessage":null/ =~ resp_body, "Unable to verify a new user was created when sending POST request to FedReg -- 'ErrorMessage did not return null'"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	begin
        assert /Status":1/ =~ resp_body, "Unable to verify a new user was created when sending POST request to FedReg -- 'Status 1, Good, was not returned in the response'"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert !/Status":3/.match(resp_body), "Unable to verify a new user was created when sending POST request to FedReg -- Status 3 returned in response"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert !/Status":4/.match(resp_body), "Unable to verify a new user was created when sending POST request to FedReg -- Status 4 returned in response"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert !/Status":5/.match(resp_body), "Unable to verify a new user was created when sending POST request to FedReg -- Status 5 returned in response"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert !/Status":8/.match(resp_body), "Unable to verify a new user was created when sending POST request to FedReg -- Status 8 returned in response"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
  end
end