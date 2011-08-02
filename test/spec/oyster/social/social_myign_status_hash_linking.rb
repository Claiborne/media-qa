require File.dirname(__FILE__) + "/../../../spec_helper"
require 'browser'
require 'social/my_ign_mod'

describe "My IGN Status Hash Linking" do
#Note: the following test cases are based on https://wiki.ign-inc.com/display/MediaQA/Regression+Test+Cases

  include My_IGN_Mod

  before(:all) do
	Configuration.config_path = File.dirname(__FILE__) + "/../../../../config/oyster/oyster_social.yml"
    @config = Configuration.new
	@browser = Browser.new
	@selenium = @browser.client
	@baseurl = @config.options['baseurl_myign'].to_s
	@baseurl_people = @config.options['baseurl_myign_people'].to_s
	login(@baseurl,"smoke")
  end

  after(:all) do
    @browser.shutdown  
  end
  
  
  it "should autocomplete" do
    @selenium.click "statusField"
	#@selenium.type "statusField", "#catherine" #not autocompleting 
    @selenium.type_keys "statusField", "#catherine" #not autocompleting
	sleep 3
	if @selenium.is_element_present("css=div#resultsList ul li")
		@selenium.get_text("css=div#resultsList ul li").match(/Catherine/).should be_true
	else
		@selenium.is_element_present("css=div#resultsList ul li").should be_true
	end
  end
end  