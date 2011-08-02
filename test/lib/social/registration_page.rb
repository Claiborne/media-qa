require 'page'

module Oyster
module Social
class RegistrationPage < Page

  def set_email
    "hello"+(Time.now.to_i).to_s+"@hello.com"
  end
  
  def set_pass
    (Time.now.to_i).to_s
  end
  
  def set_user
    "a"+(Time.now.to_i).to_s 
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
    
    response.body.to_s
  end
  
end
end
end