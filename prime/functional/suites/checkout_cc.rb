require "rubygems"
require "selenium-webdriver"
require "rspec"
require "library"

describe  "Prime Credit Card Transactions" do
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
	
	###########################################
	#     BEGIN ANNUAL SUBSCRIPTION SUITE     #
	###########################################
	it "should allow an Annual Visa transaction" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client

		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.select_subscription(@config.options['annual_name'])
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("Visa")
		payment_page.fill_cc_details({
			:card_num         => payment_page.generate_card_num("Visa"),
			:card_cvv         => payment_page.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => payment_page.generate_random_zip,
			:card_month       => payment_page.generate_random_month,
			:card_year        => payment_page.generate_random_year
		}) 
		payment_page.submit_order
		receipt_page.is_displayed.should be_true
		receipt_page.order_date.should be_true
		receipt_page.account_name("fk-auto-#{@time}").should be_true
		receipt_page.package_name(@config.options['annual_name']).should be_true
		receipt_page.package_price(@config.options['annual_price']).should be_true

		vindicia = VindiciaAPI.new
		vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['annual_autobill'])
		
		topaz = Topaz.new
		topaz.client = @browser.client
		entitlements = TopazEntitlements.new
		entitlements.client = @browser.client
		entitlements.is_user_entitled(topaz.get_topaz_id("fk-auto-#{@time}"))
    @@report.suite_end()
	end
	
	it "should allow an Annual MasterCard transaction" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client
		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.select_subscription(@config.options['annual_name'])
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("MasterCard")
		payment_page.fill_cc_details({
			:card_num         => payment_page.generate_card_num("MasterCard"),
			:card_cvv         => payment_page.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => payment_page.generate_random_zip,
			:card_month       => payment_page.generate_random_month,
			:card_year        => payment_page.generate_random_year
		})    
		payment_page.submit_order
		receipt_page.is_displayed.should be_true
		receipt_page.order_date.should be_true
		receipt_page.account_name("fk-auto-#{@time}").should be_true
		receipt_page.package_name(@config.options['annual_name']).should be_true
		receipt_page.package_price(@config.options['annual_price']).should be_true

		vindicia = VindiciaAPI.new
		vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['annual_autobill'])
		
		topaz = Topaz.new
		topaz.client = @browser.client
		entitlements = TopazEntitlements.new
		entitlements.client = @browser.client
		entitlements.is_user_entitled(topaz.get_topaz_id("fk-auto-#{@time}"))
    @@report.suite_end()
	end
	
	it "should allow an Annual American Express transaction" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client
		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.select_subscription(@config.options['annual_name'])
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("American Express")
		payment_page.fill_cc_details({
			:card_num         => payment_page.generate_card_num("American Express"),
			:card_cvv         => payment_page.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => payment_page.generate_random_zip,
			:card_month       => payment_page.generate_random_month,
			:card_year        => payment_page.generate_random_year
		})    
		payment_page.submit_order
		receipt_page.is_displayed.should be_true
		receipt_page.order_date.should be_true
		receipt_page.account_name("fk-auto-#{@time}").should be_true
		receipt_page.package_name(@config.options['annual_name']).should be_true
		receipt_page.package_price(@config.options['annual_price']).should be_true

		vindicia = VindiciaAPI.new
		vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['annual_autobill'])
		
		topaz = Topaz.new
		topaz.client = @browser.client
		entitlements = TopazEntitlements.new
		entitlements.client = @browser.client
		entitlements.is_user_entitled(topaz.get_topaz_id("fk-auto-#{@time}"))
    @@report.suite_end()
	end
	
	it "should allow an Annual Discover transaction" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client
		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.select_subscription(@config.options['annual_name'])
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("Discover")
		payment_page.fill_cc_details({
			:card_num         => payment_page.generate_card_num("Discover"),
			:card_cvv         => payment_page.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => payment_page.generate_random_zip,
			:card_month       => payment_page.generate_random_month,
			:card_year        => payment_page.generate_random_year
		})    
		payment_page.submit_order
		receipt_page.is_displayed.should be_true
		receipt_page.order_date.should be_true
		receipt_page.account_name("fk-auto-#{@time}").should be_true
		receipt_page.package_name(@config.options['annual_name']).should be_true
		receipt_page.package_price(@config.options['annual_price']).should be_true

		vindicia = VindiciaAPI.new
		vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['annual_autobill'])
		
		topaz = Topaz.new
		topaz.client = @browser.client
		entitlements = TopazEntitlements.new
		entitlements.client = @browser.client
		entitlements.is_user_entitled(topaz.get_topaz_id("fk-auto-#{@time}"))
    @@report.suite_end()
	end
	
	###########################################
	#     BEGIN 2 YEAR SUBSCRIPTION SUITE     #
	###########################################
	
	it "should allow a 2 Year Visa transaction" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client
		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.select_subscription(@config.options['2year_name'])
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("Visa")
		payment_page.fill_cc_details({
			:card_num         => payment_page.generate_card_num("Visa"),
			:card_cvv         => payment_page.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => payment_page.generate_random_zip,
			:card_month       => payment_page.generate_random_month,
			:card_year        => payment_page.generate_random_year
		})    
		payment_page.submit_order
		receipt_page.is_displayed.should be_true
		receipt_page.order_date.should be_true
		receipt_page.account_name("fk-auto-#{@time}").should be_true
		receipt_page.package_name(@config.options['2year_name']).should be_true
		receipt_page.package_price(@config.options['2year_price']).should be_true

		vindicia = VindiciaAPI.new
		vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['2year_autobill'])
		
		topaz = Topaz.new
		topaz.client = @browser.client
		entitlements = TopazEntitlements.new
		entitlements.client = @browser.client
		entitlements.is_user_entitled(topaz.get_topaz_id("fk-auto-#{@time}"))
    @@report.suite_end()
	end
	
	it "should allow a 2 Year MasterCard transaction" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client
		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.select_subscription(@config.options['2year_name'])
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("MasterCard")
		payment_page.fill_cc_details({
			:card_num         => payment_page.generate_card_num("MasterCard"),
			:card_cvv         => payment_page.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => payment_page.generate_random_zip,
			:card_month       => payment_page.generate_random_month,
			:card_year        => payment_page.generate_random_year
		})    
		payment_page.submit_order
		receipt_page.is_displayed.should be_true
		receipt_page.order_date.should be_true
		receipt_page.account_name("fk-auto-#{@time}").should be_true
		receipt_page.package_name(@config.options['2year_name']).should be_true
		receipt_page.package_price(@config.options['2year_price']).should be_true

		vindicia = VindiciaAPI.new
		vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['2year_autobill'])
		
		topaz = Topaz.new
		topaz.client = @browser.client
		entitlements = TopazEntitlements.new
		entitlements.client = @browser.client
		entitlements.is_user_entitled(topaz.get_topaz_id("fk-auto-#{@time}"))
    @@report.suite_end()
	end
	
	it "should allow an 2 Year American Express transaction" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client
		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.select_subscription(@config.options['2year_name'])
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("American Express")
		payment_page.fill_cc_details({
			:card_num         => payment_page.generate_card_num("American Express"),
			:card_cvv         => payment_page.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => payment_page.generate_random_zip,
			:card_month       => payment_page.generate_random_month,
			:card_year        => payment_page.generate_random_year
		})    
		payment_page.submit_order
		receipt_page.is_displayed.should be_true
		receipt_page.order_date.should be_true
		receipt_page.account_name("fk-auto-#{@time}").should be_true
		receipt_page.package_name(@config.options['2year_name']).should be_true
		receipt_page.package_price(@config.options['2year_price']).should be_true

		vindicia = VindiciaAPI.new
		vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['2year_autobill'])
		
		topaz = Topaz.new
		topaz.client = @browser.client
		entitlements = TopazEntitlements.new
		entitlements.client = @browser.client
		entitlements.is_user_entitled(topaz.get_topaz_id("fk-auto-#{@time}"))
    @@report.suite_end()
	end
	
	it "should allow an 2 Year Discover transaction" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client
		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.select_subscription(@config.options['2year_name'])
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("Discover")
		payment_page.fill_cc_details({
			:card_num         => payment_page.generate_card_num("Discover"),
			:card_cvv         => payment_page.generate_random_cvv,
			:name       			=> 'Frank Klun',
			:street_address   => '625 2nd Street',
			:city             => 'San Francisco',
			:state						=> 'CA',
			:zip_code         => payment_page.generate_random_zip,
			:card_month       => payment_page.generate_random_month,
			:card_year        => payment_page.generate_random_year
		})    
		payment_page.submit_order
		receipt_page.is_displayed.should be_true
		receipt_page.order_date.should be_true
		receipt_page.account_name("fk-auto-#{@time}").should be_true
		receipt_page.package_name(@config.options['2year_name']).should be_true
		receipt_page.package_price(@config.options['2year_price']).should be_true

		vindicia = VindiciaAPI.new
		vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['2year_autobill'])
		
		topaz = Topaz.new
		topaz.client = @browser.client
		entitlements = TopazEntitlements.new
		entitlements.client = @browser.client
		entitlements.is_user_entitled(topaz.get_topaz_id("fk-auto-#{@time}"))
    @@report.suite_end()
	end
	
	###########################################
	#      BEGIN TRIAL SUBSCRIPTION SUITE     #
	###########################################
	
	# it "should allow a Free Trial Visa transaction" do
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# payment_page = VindiciaPrimePayment.new
		# payment_page.client = @browser.client
		# receipt_page = VindiciaReceiptPage.new
		# receipt_page.client = @browser.client
# 		
		# subscribe_page.visit(@config.options['baseurl'])
		# #subscribe_page.logout
		# subscribe_page.select_subscription(@config.options['trial_name'])
		# subscribe_page.register_account({
			# :email		=>	"fk-auto-#{@time}@ign.com",
			# :password	=>	"boxofass",
			# :nickname	=>	"fk-auto-#{@time}"
		# })
		# subscribe_page.continue
		# payment_page.choose_card_type("Visa")
		# payment_page.fill_cc_details({
			# :card_num         => payment_page.generate_card_num("Visa"),
			# :card_cvv         => payment_page.generate_random_cvv,
			# :name       			=> 'Frank Klun',
			# :street_address   => '625 2nd Street',
			# :city             => 'San Francisco',
			# :state						=> 'CA',
			# :zip_code         => payment_page.generate_random_zip,
			# :card_month       => payment_page.generate_random_month,
			# :card_year        => payment_page.generate_random_year
		# })    
		# payment_page.submit_order
		# receipt_page.is_displayed.should be_true
		# receipt_page.order_date.should be_true
		# receipt_page.account_name("fk-auto-#{@time}").should be_true
		# receipt_page.package_name(@config.options['trial_name']).should be_true
		# receipt_page.package_price(@config.options['trial_price']).should be_true
# 
		# vindicia = VindiciaAPI.new
		# vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['trial_autobill'])
	# end
# 	
	# it "should allow a Free Trial MasterCard transaction" do
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# payment_page = VindiciaPrimePayment.new
		# payment_page.client = @browser.client
		# receipt_page = VindiciaReceiptPage.new
		# receipt_page.client = @browser.client
# 		
		# subscribe_page.visit(@config.options['baseurl'])
		# #subscribe_page.logout
		# subscribe_page.select_subscription(@config.options['trial_name'])
		# subscribe_page.register_account({
			# :email		=>	"fk-auto-#{@time}@ign.com",
			# :password	=>	"boxofass",
			# :nickname	=>	"fk-auto-#{@time}"
		# })
		# subscribe_page.continue
		# payment_page.choose_card_type("MasterCard")
		# payment_page.fill_cc_details({
			# :card_num         => payment_page.generate_card_num("MasterCard"),
			# :card_cvv         => payment_page.generate_random_cvv,
			# :name       			=> 'Frank Klun',
			# :street_address   => '625 2nd Street',
			# :city             => 'San Francisco',
			# :state						=> 'CA',
			# :zip_code         => payment_page.generate_random_zip,
			# :card_month       => payment_page.generate_random_month,
			# :card_year        => payment_page.generate_random_year
		# })    
		# payment_page.submit_order
		# receipt_page.is_displayed.should be_true
		# receipt_page.order_date.should be_true
		# receipt_page.account_name("fk-auto-#{@time}").should be_true
		# receipt_page.package_name(@config.options['trial_name']).should be_true
		# receipt_page.package_price(@config.options['trial_price']).should be_true
# 
		# vindicia = VindiciaAPI.new
		# vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['trial_autobill'])
	# end
# 	
	# it "should allow a Free Trial American Express transaction" do
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# payment_page = VindiciaPrimePayment.new
		# payment_page.client = @browser.client
		# receipt_page = VindiciaReceiptPage.new
		# receipt_page.client = @browser.client
# 		
		# subscribe_page.visit(@config.options['baseurl'])
		# #subscribe_page.logout
		# subscribe_page.select_subscription(@config.options['trial_name'])
		# subscribe_page.register_account({
			# :email		=>	"fk-auto-#{@time}@ign.com",
			# :password	=>	"boxofass",
			# :nickname	=>	"fk-auto-#{@time}"
		# })
		# subscribe_page.continue
		# payment_page.choose_card_type("American Express")
		# payment_page.fill_cc_details({
			# :card_num         => payment_page.generate_card_num("American Express"),
			# :card_cvv         => payment_page.generate_random_cvv,
			# :name       			=> 'Frank Klun',
			# :street_address   => '625 2nd Street',
			# :city             => 'San Francisco',
			# :state						=> 'CA',
			# :zip_code         => payment_page.generate_random_zip,
			# :card_month       => payment_page.generate_random_month,
			# :card_year        => payment_page.generate_random_year
		# })    
		# payment_page.submit_order
		# receipt_page.is_displayed.should be_true
		# receipt_page.order_date.should be_true
		# receipt_page.account_name("fk-auto-#{@time}").should be_true
		# receipt_page.package_name(@config.options['trial_name']).should be_true
		# receipt_page.package_price(@config.options['trial_price']).should be_true
# 
		# vindicia = VindiciaAPI.new
		# vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['trial_autobill'])
	# end
# 	
	# it "should allow a Free Trial Discover transaction" do
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# payment_page = VindiciaPrimePayment.new
		# payment_page.client = @browser.client
		# receipt_page = VindiciaReceiptPage.new
		# receipt_page.client = @browser.client
# 		
		# subscribe_page.visit(@config.options['baseurl'])
		# #subscribe_page.logout
		# subscribe_page.select_subscription(@config.options['trial_name'])
		# subscribe_page.register_account({
			# :email		=>	"fk-auto-#{@time}@ign.com",
			# :password	=>	"boxofass",
			# :nickname	=>	"fk-auto-#{@time}"
		# })
		# subscribe_page.continue
		# payment_page.choose_card_type("Discover")
		# payment_page.fill_cc_details({
			# :card_num         => payment_page.generate_card_num("Discover"),
			# :card_cvv         => payment_page.generate_random_cvv,
			# :name       			=> 'Frank Klun',
			# :street_address   => '625 2nd Street',
			# :city             => 'San Francisco',
			# :state						=> 'CA',
			# :zip_code         => payment_page.generate_random_zip,
			# :card_month       => payment_page.generate_random_month,
			# :card_year        => payment_page.generate_random_year
		# })    
		# payment_page.submit_order
		# receipt_page.is_displayed.should be_true
		# receipt_page.order_date.should be_true
		# receipt_page.account_name("fk-auto-#{@time}").should be_true
		# receipt_page.package_name(@config.options['trial_name']).should be_true
		# receipt_page.package_price(@config.options['trial_price']).should be_true
# 
		# vindicia = VindiciaAPI.new
		# vindicia.verify_transaction(vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com"), @config.options['trial_autobill'])
	# end
end