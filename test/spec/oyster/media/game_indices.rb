require 'rspec'
require 'pathconfig'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'widget/top_games'

include OpenPage
include FeChecker
include TopGames

#def platform_list; ['all','xbox-360','ps3','pc','wii-u','3ds','vita','iphone']; end
#def genre_list; ['all','action','adventure','fighting','rpg']; end

def platform_list; ['all','xbox-360']; end
def genre_list; ['all','action']; end

def common_assertions(object_list, object_title, object_list_object, object_genre, item_platform, old_page = true)
  
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
    @doc.at_css("div.#{object_list} div.#{object_title}").should be_true
    @doc.at_css("div.#{object_list} div.#{object_title}").text.delete("^a-zA-Z").length.should > 0
  end
  
  it "should display a title for each game" do
    @doc.css("div.#{object_list} div.#{object_list_object}").each do |game|
      game.at_css("div.#{object_title} a").should be_true
      game.at_css("div.#{object_title} a").text.delete("^a-zA-Z").length.should > 0
    end
  end
  
  it "should display a platform for each game" do
    @doc.css("div.#{object_list} div.#{object_list_object}").each do |game|
      game.at_css("span.#{item_platform}").should be_true
      game.at_css("span.#{item_platform}").text.delete("^a-zA-Z").length.should > 0
    end
  end
  
  it "should display a genre for each game" do
    @doc.css("div.#{object_list} div.#{object_list_object}").each do |game|
      game.at_css("span.#{object_genre}").should be_true
      game.at_css("span.#{object_genre}").text.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  it "should display a release data for each game" do
    @doc.css("div.#{object_list} div.#{object_list_object}").each do |game|
      game.at_css("div.releaseDate").should be_true
      game.at_css("div.releaseDate").text.delete("^a-zA-Z0-9").length.should > 0
    end
  end
  
  if old_page then
  platform_list.each do |platform| 
    it "should include a link to sort by platform=#{platform}" do
      @doc.at_css('div.container_24 ul.platform-filters li a').attribute("href*='platform=#{platform}'")
    end
  end
  end
  
end

def review_assertions(object_list, object_list_object)

  it "should return a review score for each game displayed", :smoke => true do
    @doc.css("div.#{object_list} div.#{object_list_object}").each do |game_list|
      game_list.at_css('span.scoreBox-score').should be_true
      game_list.css('span.scoreBox-score').text.delete("^0-9").length.should > 0
      game_list.at_css('span.scoreBox-scorePhrase').should be_true
      game_list.css('span.scoreBox-scorePhrase').text.delete("^a-zA-Z").length.should > 0
    end
  end

end

def upcoming_assertions

  ##todo

end

####################################################################################

describe "Game Indices -- /games/reviews" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/reviews"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
    
  common_assertions('itemList', 'item-title', 'itemList-item', 'item-genre', 'item-platform', false)
  
  review_assertions('gameList', 'gameList-game')

end

####################################################################################

platform_list.each do |platform|
describe "Game Indices -- /games/reviews/#{platform}" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/reviews/#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  it "should display only #{platform} games" do
    if platform == 'wii-u'
        @doc.css("div.gameList div.gameList-game").each do |game|
          (
          game.at_css("span[class='game-platform #{platform}']") ||
          game.at_css("span[class='game-platform wii']")
          ).should be_true
        end
    elsif platform == '3ds'
      @doc.css("div.gameList div.gameList-game").each do |game|
        (
        game.at_css("span[class='game-platform #{platform}']") ||
        game.at_css("span[class='game-platform ds']")  ||
        game.at_css("span[class='game-platform nds']") ||
            game.at_css("span[class='game-platform dsi']")
        ).should be_true
      end
    elsif platform != 'all'
      @doc.css("div.gameList div.gameList-game").each do |game|
        game.at_css("span[class='game-platform #{platform}']").should be_true
      end
    end
  end

  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')
  
  review_assertions('gameList', 'gameList-game')

end
end

####################################################################################

platform_list.each do |platform|
genre_list.each do |genre|
describe "Game Indices -- /games/reviews/#{platform}?genre=#{genre}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/reviews/#{platform}?genre=#{genre}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do

  end

  after(:each) do

  end

  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')
  
  review_assertions('gameList', 'gameList-game')

end
end
end

####################################################################################

describe "Game Indices -- /games/editors-choice" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/editors-choice"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')
  
  review_assertions('gameList', 'gameList-game')
  
end

####################################################################################

platform_list.each do |platform|
describe "Game Indices -- /games/editors-choice/#{platform}" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/editors-choice/#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')
  
  review_assertions('gameList', 'gameList-game')

end
end

####################################################################################

platform_list.each do |platform|
genre_list.each do |genre|
describe "Game Indices -- /games/editors-choice/#{platform}?genre=#{genre}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/editors-choice/#{platform}?genre=#{genre}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do

  end

  after(:each) do

  end

  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')
  
  review_assertions('gameList', 'gameList-game')
  
end
end
end

####################################################################################

describe "Game Indices -- /games/upcoming" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  common_assertions('itemList', 'item-title', 'itemList-item', 'item-genre', 'item-platform', false)
  
end

####################################################################################

platform_list.each do |platform|
describe "Game Indices -- /games/upcoming/#{platform}" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming/#{platform}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')

end
end

####################################################################################

platform_list.each do |platform|
genre_list.each do |genre|
describe "Game Indices -- /games/upcoming/#{platform}?genre=#{genre}" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming/#{platform}?genre=#{genre}"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do

  end

  after(:each) do

  end

  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')

end
end
end

####################################################################################

describe "Game Indices -- /games/upcoming?filter=latest" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming?filter=latest"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

  common_assertions('itemList', 'item-title', 'itemList-game', 'item-genre', 'item-platform', false)
  
end

####################################################################################

platform_list.each do |platform|
describe "Game Indices -- /games/upcoming/#{platform}?filter=latest" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming/#{platform}?filter=latest"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')

end
end

####################################################################################

platform_list.each do |platform|
genre_list.each do |genre|
describe "Game Indices -- /games/upcoming/#{platform}?genre=#{genre}&filter=latest" do

  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games/upcoming/#{platform}?genre=#{genre}&filter=latest"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do

  end

  after(:each) do

  end

  common_assertions('gameList', 'game-title', 'gameList-game', 'game-genre', 'game-platform')

end
end
end

####################################################################################

describe "Game Indices -- /games" do
  
  before(:all) do
    PathConfig.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = PathConfig.new
    @page = "http://#{@config.options['baseurl']}/games"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it 'should return a 200' do
  end

end