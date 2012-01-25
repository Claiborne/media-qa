##################################################
#
# This is the helper file for the /subscribe page
#
###################################################

class VindiciaSubscribePage < Page
  
  	#include ScreenshotHelper 
  	#include SqlServer
  
  	def visit
   		@client.get "http://fklun.dev.s.ign.com/subscribe"
   		#@client.get "http://s.ign.com/subscribe"
  	end  

  	def select_subscription(plan_name)
    	case plan_name
      	when 'Prime - Quarterly'
        	plan_id = 'plan-Prime - Quarterly'
      	when 'Prime - Annual'
        	plan_id = 'plan-Prime - Annual'
      	when 'Prime 2 Year'
        	plan_id = 'plan-Prime - 2 Year'
        	#assert_element('//li[@id='90df8e0e-4506-47f8-a370-fa3fc3bf75f3']/div/div/div[p=$79.95 for 2 years]')     
        	#assert_element('//li[@id='90df8e0e-4506-47f8-a370-fa3fc3bf75f3']/div/div[1]/div/p[@class='normal smaller price']')
        	#assert_equal '$79.95 for 2 years', @client.get_text('//li[@id='90df8e0e-4506-47f8-a370-fa3fc3bf75f3']/div/div[1]/div/p[@class='normal smaller price']')
    	end
  		@client.find_element(:xpath, "//ul[@id='chooseplan']/li/div/div/label[@for='#{plan_id}']").click
  	end
  
  	def enter_promo_code(code)
  		@client.find_element(:id, "promoCodeTextBox").send_keys code
			@client.find_element(:id, "submitplan-btn").click
  	end

  	def register_account(info)
			@client.find_element(:id, "register_email").send_keys info[:email]
			@client.find_element(:id, "register_password").send_keys info[:password]
			@client.find_element(:id, "register_nickname").send_keys info[:nickname]
  	end

  	def login_account(info)
    	@client.find_element(:id, "email").send_keys info[:email]
			@client.find_element(:id, "password").send_keys info[:password]
  	end
  
  	def logout
  		begin 
  			@client.find_element(:id, "logoutHyperLink").click
 				return "User has been logged out"
  		rescue 
  			return "Already logged out. Continuing with test."
 			end
  	end
  	
  	def continue		
  		@client.find_element(:id, "continueBtn").click  		
  	end
end