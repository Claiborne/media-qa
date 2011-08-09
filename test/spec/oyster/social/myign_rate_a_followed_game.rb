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

anime.ign.com
bestof.ign.com
bluray.ign.com
buyersguide.gamespy.com
buyersguide.ign.com
cars.ign.com
comics.ign.com
cube.gamespy.com
cube.ign.com
dreamcast.ign.com
ds.gamespy.com
ds.ign.com
dvd.ign.com
e3.gamespy.com
entertainment.ign.com
faqs.ign.com
gameboy.ign.com
games.ign.com
gamespy.com
cars.ign.com
comics.ign.com
cube.gamespy.com
dreamcast.ign.com
ds.gamespy.com
ds.ign.com
dvd.ign.com
e3.gamespy.com
entertainment.ign.com
faqs.ign.com
gameboy.ign.com
games.ign.com
gba.gamespy.com
gear.ign.com
goty.gamespy.com
guides.ign.com
ign64.ign.com
insider.ign.com
live.ign.com
mac.ign.com
mostwanted.gamespy.com
movies.ign.com
music.ign.com
ngage.ign.com
pc.gamespy.com
pc.ign.com
ps2.gamespy.com
ps2.ign.com
ps3.gamespy.com
ps3.ign.com
psp.gamespy.com
psp.ign.com
psx.ign.com
retro.ign.com
sports.ign.com
stars.ign.com
top100.ign.com
bluray.ign.com
buyersguide.gamespy.com
buyersguide.ign.com
comics.ign.com
cube.gamespy.com
cube.ign.com
dreamcast.ign.com
ds.gamespy.com
ds.ign.com
dvd.ign.com
e3.gamespy.com
entertainment.ign.com
faqs.ign.com
gameboy.ign.com
games.ign.com
gamespy.com
gba.gamespy.com
gear.ign.com
goty.gamespy.com
guides.ign.com
ign.com
ign64.ign.com
insider.ign.com
mac.ign.com
mostwanted.gamespy.com
movies.ign.com
music.ign.com
ngage.ign.com
pc.ign.com
ps2.ign.com
ps3.ign.com
psp.ign.com
psx.ign.com
retro.ign.com
sports.ign.com
stars.ign.com
top100.ign.com
tv.ign.com
video.ign.com
wii.gamespy.com