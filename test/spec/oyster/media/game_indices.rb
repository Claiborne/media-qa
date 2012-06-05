require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'widget/top_games'

include OpenPage
include FeChecker
include TopGames

#def platform_list; ['all','xbox-360','ps33','pc','wii','3ds','playstation-vita','iphone']; end
#def genre_list; ['all','action','adventure','fighting','music','rpg','racing','shooter','sports','strategy']; end

def platform_list; ['all','xbox-360']; end
def genre_list; ['all']; end

def common_assertions
  
  it "should return 200", :smoke => true do
  end

  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end
  
  context "Top Games Out Now Widget" do
    widget_top_games('Games Out Now', 3)
  end
  
  context "Top Games Coming Soon Widget" do
    widget_top_games('Games Coming Soon', 3)
  end
  
  it "should return at least one game", :smoke => true do
    @doc.at_css('div.gameList div.game-title').should be_true
    @doc.at_css('div.gameList div.game-title').text.delete("^a-zA-Z").length.should > 0
  end
  
  it "should display a title for each game" do
    @doc.css('div.gameList div.gameList-game').each do |game|
      game.at_css('div.game-title a').should be_true
      game.at_css('div.game-title a').text.delete("^a-zA-Z").length.should > 0
    end
  end
  
  it "should display a platform for each game" do
    @doc.css('div.gameList div.gameList-game').each do |game|
      game.at_css('span.game-platform').should be_true
      game.at_css('span.game-platform').text.delete("^a-zA-Z").length.should > 0
    end
  end
  
  it "should display a genre for each game" do
    @doc.css('div.gameList div.gameList-game').each do |game|
      game.at_css('span.game-genre').should be_true
      game.at_css('span.game-genre').text.delete("^a-zA-Z").length.should > 0
    end
  end
  
  it "should display a release data for each game" do
    @doc.css('div.gameList div.gameList-game').each do |game|
      game.at_css('div.releaseDate').should be_true
      game.at_css('div.releaseDate').text.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  platform_list.each do |platform|
    it "should include a link to sort by platform=#{platform}" do
      @doc.at_css('div.container_24 ul.platform-filters li a').attribute("href*='platform=#{platform}'")
    end
  end
  
end

def review_assertions

  it "should return a review score for each game displayed", :smoke => true do
    @doc.css('div.gameList div.gameList-game').each do |game_list|
      game_list.css('div.scoreBox-score').should be_true
      game_list.css('div.scoreBox-score').text.delete("^0-9").length.should > 0
      game_list.css('div.scoreBox-scorePhrase').should be_true
      game_list.css('div.scoreBox-scorePhrase').text.delete("^a-zA-Z").length.should > 0
    end
  end

end

def upcoming_assertions

  ##todo

end

####################################################################################

describe "Game Indices -- /games/reviews" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/reviews"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
    
  common_assertions
  
  review_assertions

end

####################################################################################

platform_list.each do |platform|
describe "Game Indices -- /games/reviews?platform=#{platform}" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/reviews?platform=#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions
  
  review_assertions

end
end

####################################################################################

genre_list.each do |genre|
describe "Game Indices -- /games/reviews?genre=#{genre}&platform=all" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/reviews?genre=#{genre}&platform=all"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions
  
  review_assertions

end
end

####################################################################################

platform_list.each do |platform|
genre_list.each do |genre|
describe "Game Indices -- /games/reviews?genre=#{genre}&platform=#{platform}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/reviews?genre=#{genre}&platform=#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do

  end

  after(:each) do

  end

  common_assertions
  
  review_assertions

end
end
end

####################################################################################

describe "Game Indices -- /games/editors-choice" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/editors-choice"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  common_assertions
  
  review_assertions
  
end

####################################################################################

platform_list.each do |platform|
describe "Game Indices -- /games/editors-choice?platform=#{platform}" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/editors-choice?platform=#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions
  
  review_assertions

end
end

####################################################################################

genre_list.each do |genre|
describe "Game Indices -- /games/editors-choice?genre=#{genre}&platform=all" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/editors-choice?genre=#{genre}&platform=all"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions
  
  review_assertions

end
end

####################################################################################

platform_list.each do |platform|
genre_list.each do |genre|
describe "Game Indices -- /games/editors-choice?genre=#{genre}&platform=#{platform}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/editors-choice?genre=#{genre}&platform=#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do

  end

  after(:each) do

  end

  common_assertions
  
  review_assertions

end
end
end

####################################################################################

describe "Game Indices -- /games/upcoming" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  common_assertions
  
end

####################################################################################

platform_list.each do |platform|
describe "Game Indices -- /games/upcoming?platform=#{platform}" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming?platform=#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions

end
end

####################################################################################

genre_list.each do |genre|
describe "Game Indices -- /games/upcoming?genre=#{genre}&platform=all" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming?genre=#{genre}&platform=all"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions

end
end

####################################################################################

platform_list.each do |platform|
genre_list.each do |genre|
describe "Game Indices -- /games/upcoming?genre=#{genre}&platform=#{platform}" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming?genre=#{genre}&platform=#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do

  end

  after(:each) do

  end

  common_assertions

end
end
end

####################################################################################

describe "Game Indices -- /games/upcoming?filter=top" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming?filter=top"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  common_assertions
  
end

####################################################################################

platform_list.each do |platform|
describe "Game Indices -- /games/upcoming?platform=#{platform}&filter=top" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming?platform=#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions

end
end

####################################################################################

genre_list.each do |genre|
describe "Game Indices -- /games/upcoming?genre=#{genre}&platform=all&filter=top" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming?genre=#{genre}&platform=all"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions

end
end

####################################################################################

platform_list.each do |platform|
genre_list.each do |genre|
describe "Game Indices -- /games/upcoming?genre=#{genre}&platform=#{platform}&filter=top" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming?genre=#{genre}&platform=#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do

  end

  after(:each) do

  end

  common_assertions

end
end
end

####################################################################################

describe "Game Indices -- /games" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should..."

end