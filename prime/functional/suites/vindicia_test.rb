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

	it "should get the autobill status" do

		vindicia = VindiciaAPI.new
		puts vindicia.get_autobill_status("fklun-auto-test-432342@ign.com")

	end
end