require "rubygems"
require "selenium-webdriver"
require "rspec"
require "library"

describe  "Account Management" do
	before(:all) do
		Configuration.config_path = File.dirname(__FILE__) + "/../../config/config.yml"
		@config = Configuration.new
	end
	
	before(:each) do
		Browser.type = @config.browser['browser']
		@browser = Browser.new
		
		@time = CustomTime.new
		@time = @time.get_int_time/2
	end
	
	after(:each) do
		@browser.shutdown()
	end
	
	it "should allow a user to change their payment method" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		update_payment_method = UpdatePaymentMethod.new
		update_payment_method.client = @browser.client
		prime_manage_page = PrimeManage.new
		prime_manage_page.client = @browser.client
		vindicia = VindiciaAPI.new


		subscribe_page.visit(@config.options['baseurl'])
		subscribe_page.login_account({
			:email		=>	"fk-auto-665238534@ign.com",
			:password	=>	"boxofass"
		})
		if subscribe_page.continue == 'retry'
			subscribe_page.visit(@config.options['baseurl'])		
		end
		update_payment_method.visit(@config.options['baseurl'])
		new_payment_method = vindicia.get_new_payment_method("fk-auto-664114939@ign.com")
		update_payment_method.choose_card_type(new_payment_method)
		update_payment_method.fill_cc_details({
			:card_num         => update_payment_method.generate_card_num(new_payment_method),
			:card_cvv         => update_payment_method.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => update_payment_method.generate_random_zip,
			:card_month       => update_payment_method.generate_random_month,
			:card_year        => update_payment_method.generate_random_year
		})
		update_payment_method.submit_order
		prime_manage_page.visit(@config.options['baseurl'])
		#check vindicia to make sure the autobill is using the new payment method (visa, mc, discover, amex, etc.)
		vindicia.get_current_payment_method("fk-auto-664114939@ign.com").should eql new_payment_method
		#check the /prime-manage page to make sure the correct account appears (last four digits)
		last_four = prime_manage_page.get_last_four.to_sr
		last_four.include? vindicia.get_last_four("fk-auto-664114939@ign.com")
		
	end
	
	# it "should allow a user to renew their subscription" do
		# subsribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
# 		
		# subscribe_page.visit(@config.options['baseurl'])
		# subscribe_page.login_account({
			# :email		=>	"fk-auto-664114939@ign.com",
			# :password	=>	"boxofass"
		# })
		# subscribe_page.continue
# 		
	# end
	
end