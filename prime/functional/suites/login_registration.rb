require "rubygems"
require "selenium-webdriver"
require "rspec"
require "library"

describe  "Prime Login and Registration" do
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
	
	it "should allow a user to log in" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.login_account({
			:email		=>	"fklun-auto-test-3@ign.com",
			:password	=>	"boxofass"
		})
		subscribe_page.continue
		payment_page.is_displayed.should be_true
	end
	
	it "should allow a user to register" do
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		
		subscribe_page.visit(@config.options['baseurl'])
		#subscribe_page.logout
		subscribe_page.register_account({
			:email		=> "fklun-auto-#{@time}@ign.com",
			:password => "boxofass",
			:nickname => "fklun-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.is_displayed.should be_true
	end
end