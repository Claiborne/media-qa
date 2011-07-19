module Oyster
 module Social
  class LoginPage < Page
 
    def visit(url="http://#{@config.options['baseurl}/login")
     @client.open(url)
    end

    def login(user, password)
     @client.type 'emailField', user
     @client.type 'passwordField', password
     @client.click 'SIGN IN'
     @client.wait
    end

    def signup
     @client.click 'SIGN UP'
     @client.wait
    end  

    def login_openid(provider)
      @client.click "/button[@class='#{provider}']"
      @client.wait
    end
  end
 end
end 
