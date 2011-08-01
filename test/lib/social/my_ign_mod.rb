module My_IGN_Mod

  def open(url)
    @selenium.open(url)
	while @selenium.get_title == "IGN Advertisement"
		@selenium.click("css=a")
		@selenium.wait_for_page_to_load "40"
	end
  end
  
  def click(url)
    @selenium.click(url)
	@selenium.wait_for_page_to_load "40"
	while @selenium.get_title == "IGN Advertisement"
		@selenium.click("css=a")
	end
  end
  
  def login(env, acct)
	@selenium.open("http://#{env}/login?r=http://#{env}/")
	@selenium.click "emailField"
    @selenium.type "emailField", "#{acct}test@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
  end
  
  def set_new_account_vars
  	@email_val = "hello"+(Time.now.to_i).to_s+"@hello.com"
	@password_val = (Time.now.to_i).to_s
	@username_val = "a"+(Time.now.to_i).to_s
  end
  
  def register_post(email_val, password_val, username_val)
	http = Net::HTTP.new("fedreg-api.ign.com")

	request = Net::HTTP::Post.new("/3.0/FedRegService.svc/users/json", {'Content-Type' => 'application/json'})
	
	# SETUP PARAM VALS FOR JSON REQ BODY
	request.body = 
	{
	"AppKey" => "www.ign.com", 
	"Email" => email_val, 
	"Password" => password_val,
	"Nickname" => username_val
	}.to_json

	response = http.request(request)
	
	resp_body = response.body.to_s
	
	# ASSERT BODY RESPONSE RETURNS "OK"

    /ErrorMessage":null/.should =~ resp_body

    /Status":1/.should =~ resp_body

	/Status":3/.match(resp_body).should be_nil

    /Status":4/.match(resp_body).should be_nil

    /Status":5/.match(resp_body).should be_nil

    /Status":8/.match(resp_body).should be_nil

  end
end