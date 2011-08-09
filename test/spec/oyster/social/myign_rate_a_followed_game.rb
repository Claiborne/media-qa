require File.dirname(__FILE__) + "/../../spec_helper"
require 'browser'
require 'social/login_page'
require 'social/my_profile_page'
require 'social/my_games_page'

describe "My IGN Rate A Followed Game" do

  before(:all) do
	Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_social.yml"
    @config = Configuration.new
	
	@baseurl = @config.options['baseurl_myign'].to_s
	@baseurl_people = @config.options['baseurl_myign_people'].to_s
  end
  
  before(:each) do
    @browser = Browser.new
	@login_page = Oyster::Social::LoginPage.new @browser.client, @config
	@profile_page = Oyster::Social::MyProfilePage.new @browser.client, @config
	@games_page = Oyster::Social::MyGamesPage.new @browser.client, @config
    
    @login_page.visit
    @login_page.signin("smoketest@testign.com", "testpassword")
  end

  after(:each) do
    @browser.shutdown   
  end
  
  it "should be able to rate a followed game" do
	@games_page.visit
	@games_page.rate_a_game.should be_true
  end

end
