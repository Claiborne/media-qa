require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'

include OpenPage
include FeChecker

def common_assertions
  it "should return 200", :smoke => true do
  end

  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end
end

platform_list = ['all','xbox-360','playstation-3','pc','wii','nintendo-3ds','playstation-vita','iphone']
genre_list = ['all','action','action,rpg','adventure','fighting','music','rpg','racing','shooter','sports','strategy']

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
  
  common_assertions

end