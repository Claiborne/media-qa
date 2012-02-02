##################################################
#
# This is the helper file for the /subscribe page
#
###################################################

class VindiciaSubscribePage < Page
	
	def visit(baseurl)
		@client.get "http://#{baseurl}/subscribe"
	end  
	
	def select_subscription(plan_name)
		# case plan_name
		# when 'Prime - Free Trial'
			# plan_id = 'plan-Prime 30 Day Trial'
		# when 'Prime 30 Day Trial'
		# when 'Prime - Annual'
			# plan_id = 'plan-Prime - Annual'
		# when 'Prime - 2 Year'
			# plan_id = 'plan-Prime - 2 Year'
		# end
		plan_id = "plan-" + plan_name
		#the xpath is different for packages that don't have a sign-up bonus hence the two different paths
		#if it fails it will try the next path
		begin 
			@client.find_element(:xpath, "//ul[@id='chooseplan']/li/div/div/label[@for='#{plan_id}']").click
		rescue
			@client.find_element(:xpath, "//ul[@id='chooseplan']/li/div/label[@for='#{plan_id}']").click
		end
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
	
	def is_displayed
		puts "Is Subscribe Page displayed?"
  	begin
  		if @client.find_element(:class,"prime-hdrtext").text.include? "Sign-up"
 				puts "Yes!"
 				return true
 			else
 				raise "Subscribe Page page not displayed"
 			end
 		rescue Exception=>e
 			puts e
 		end
	end
end