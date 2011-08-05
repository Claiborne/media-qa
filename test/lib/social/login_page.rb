require 'page'
require 'providers'

module Oyster
 module Social
  class LoginPage < Page
 
  def visit(url="http://#{@config.options['baseurl_myign']}/login")
     @client.open(url)
     @client.wait_for_page_to_load
     while @client.get_title == "IGN Advertisement"                                   	    		 
        @client.click("css=a")
        @client.wait_for_page_to_load "40"
     end
  end

    def login(user, password)
     @client.type 'emailField', user
     @client.type 'passwordField', password
     @client.click "//button[@class='submit']"
     @client.wait_for_page_to_load "40"
	 while @client.get_title == "IGN Advertisement"                                   	    		 
        @client.click("css=a")
        @client.wait_for_page_to_load "40"
     end
    end
    
    def signin(user, password)
      @client.type "emailField", user
      @client.type "passwordField", password
      @client.click "signinButton"
      @client.wait_for_page_to_load
      while @client.get_title == "IGN Advertisement"                                     	    		 
        @client.click("css=a")
        @client.wait_for_page_to_load "40"
      end
    end

    def signup
     @client.click 'SIGN UP'
     @client.wait
    end  

    def login_openid(provider)
      @client.click "//button[@class='#{provider}']"
      @client.wait_for_page_to_load
      provider_page = ProviderLoginPage.new @client, @config, provider
      provider_page
    end

    def assert_invalid_authentication_message
      expected_msg = 'You cannot login using the current credentials. Please try again.'
      @client.get_text('//span[@class="errorMsg"]').should == expected_msg

    end
  end
 end
end 
