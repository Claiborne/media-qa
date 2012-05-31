require 'rspec'
require 'configuration'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'json'

include OpenPage
include FeChecker

############## METHODS ############## 

def common_gob_checks
  
  it "should return 200", :smoke => true do
  end

  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end

  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end
  
end

################################## BEGIN SPEC ################################## 

describe "Released GOB Page -- /games/mass-effect-3/xbox-360-14235014" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/mass-effect-3/xbox-360-14235014"
    @doc = nokogiri_not_301_open(@page)    
  end

  before(:each) do
    
  end

  after(:each) do

  end

  common_gob_checks
  
  context "Game Highlights" do
    
    it "should link to the review article" do
      RestClient.get @doc.css('div#mainArticle a.reviewTitle').attribute('href').to_s
    end

    it "should link to the review video" do
      RestClient.get @doc.css('div#mainArticle a.highlight-link').attribute('href').to_s
    end

    it "should display a review score" do
      @doc.css('div.leftNav span.rating').text.delete('^0-9').length.should > 0
    end
    
    it "should display the review description" do
      @doc.css('div.leftNav div.scoreBox-description').text.delete('^a-zA-Z').length > 0
    end

    it "should display box art" do
      RestClient.get @doc.css('div.leftNav img.highlight-boxArt').attribute('src').to_s
    end
    
  end
  
  context "Wiki Highlights" do
    
    it "should display at least two thumbnails" do
      @doc.css("div.wikiToC-pair div.wikiToC-image img[src*='http']").count.should > 1
    end
    
    it "should display a thumbnail for each TOC item" do
      @doc.css('div.wikiToC-pair div.wikiToC-item').each do |wiki_item| 
        RestClient.get wiki_item.css('img.wide').attribute('src').to_s
      end
    end
    
    it "should display a title for each TOC item" do
      @doc.css('div.wikiToC-pair div.wikiToC-item').each do |wiki_item|
        wiki_item.css('a.wikiToC-title').text.delete('^a-zA-Z0-9')
      end
    end
    
    it "should only contain links to Wikis" do
      @doc.css('div.wikiToC-item a').each do |wiki_link|
        wiki_link.attribute('href').to_s.match(/ign.com\/wikis\//).should be_true
      end
    end
    
    it "should only contain links to a wiki with a gob id of 14235014" do
      @doc.css('div.wikiToC-item a').each do |wiki_link|
        wiki_link.attribute('href').to_s.match(/14235014/).should be_true
      end
    end
    
  end
  
  context "Popular Threads" do
    
    it "should display at least one thread" do
      @doc.css("div.mainContent div.popularthreads_link a[href*='http']").text.delete('^a-zA-Z0-9').length.should > 0  
    end
    
    it "should display at least three threads" do
      @doc.css("div.mainContent div.popularthreads_link a[href*='http']").count.should > 0  
      @doc.css("div.mainContent div.popularthreads_link a[href*='http']").each do |board_link|
        board_link.text.delete('^a-zA-Z0-9').length.should > 0  
      end
    end
    
    it "should only contain links to Boards" do
      @doc.css('div.popularthreads_link a').each do |boards_link|
        boards_link.attribute('href').to_s.match(/ign.com\/boards\//).should be_true
      end
    end
    
    it "should display the author's name for each thread" do
      @doc.css('div.popularthreads_link').count.should == @doc.css('div.popularthreads-author').count
      @doc.css('div.popularthreads-author').each do |board_author|
        board_author.text.gsub(board_author.css('span').text.to_s,"").delete('^a-zA-Z0-9').length.should > 0
      end
    end
    
    it "should display the date for each thread" do
      @doc.css('div.popularthreads_link').count.should == @doc.css('span.popularthreads-postDate').count
      @doc.css('span.popularthreads-postDate').each do |board_date|
        board_date.text.delete('^a-zA-Z0-9').length.should > 0
      end
    end
    
  end
  
  context "About This Game" do
    
    ['summary','specifications','features','editions'].each do |game_info|
      it "should contain text in the when sorting by '#{game_info}'" do
        @doc.css("div.aboutGame div##{game_info}").text.delete('^A-Z').length.should > 0
      end
    end
    
    it "should display a release date of March 6, 2012" do
      @doc.css("div#summary div[class='gameInfo-list leftColumn']").text.match(/Release Date: March 6, 2012/).should be_true
    end
    
    it "should display the a rating of M for Mature" do
      @doc.css("div#summary div[class='gameInfo-list leftColumn']").text.match(/M for Mature: Blood, Partial Nudity, Sexual Content, Strong Language, Violence/).should be_true
    end
    
    it "should display the genre as RPG" do
      @doc.css("div#summary").text.delete('^a-zA-Z0-9').match(/GenreRPG/).should be_true
    end
    
    it "should display the publisher as Electronic Arts" do
      @doc.css("div#summary").text.delete('^a-zA-Z0-9').match(/PublisherElectronicArts/).should be_true
    end
    
    it "should display the developer as Bioware" do
      @doc.css("div#summary").text.delete('^a-zA-Z0-9').match(/DeveloperBioWare/).should be_true
    end
    
  end
  
  context "Games You May Like" do
    
    it "should be on the page once" do
      @doc.css('div#GameYouMayLike').count.should == 1
    end
    
    it "should display three game boxart images when same by genre" do
      @doc.css('div#GameYouMayLike_Details_RPG a img').count.should == 3
      @doc.css('div#GameYouMayLike_Details_RPG').each do |game|
        RestClient.get game.css('a img').attribute('src').to_s
      end
    end
    
    it "should display three game boxart images when same by platform" do
      @doc.css("div[id='GameYouMayLike_Details_Xbox 360'] a img").count.should == 3
      @doc.css("div[id='GameYouMayLike_Details_Xbox 360']").each do |game|
        RestClient.get game.css('a img').attribute('src').to_s
      end
    end
    
    it "should display three game titles when same by genre" do
      @doc.css('div#GameYouMayLike_Details_RPG div.GameYouMayLike_Details_Game_Name a').count.should == 3
      @doc.css('div#GameYouMayLike_Details_RPG div.GameYouMayLike_Details_Game_Name').each do |game|
        game.css('a').text.delete('^a-z').length.should > 0
      end
    end
    
    it "should display three game titles when same by platform" do
      @doc.css("div[id='GameYouMayLike_Details_Xbox 360'] div.GameYouMayLike_Details_Game_Name a").count.should == 3
      @doc.css("div[id='GameYouMayLike_Details_Xbox 360'] div.GameYouMayLike_Details_Game_Name").each do |game|
        game.css('a').text.delete('^a-z').length.should > 0
      end
    end
    
    it "should display a summary for each game when same by genre" do
      @doc.css('div#GameYouMayLike_Details_RPG div.GameYouMayLike_Details_Game_Description').count.should == 3
      @doc.css('div#GameYouMayLike_Details_RPG div.GameYouMayLike_Details_Game_Description').each do |game|
        game.text.delete('^a-z').length.should > 0
      end
    end
    
    it "should display a summary for each game when same by platform" do
      @doc.css("div[id='GameYouMayLike_Details_Xbox 360'] div.GameYouMayLike_Details_Game_Description").count.should == 3
      @doc.css("div[id='GameYouMayLike_Details_Xbox 360'] div.GameYouMayLike_Details_Game_Description").each do |game|
        game.text.delete('^a-z').length.should > 0
      end
    end
    
  end
  
  context "Latest Stories" do
    
    it "should display at least one article" do
      @doc.css('div.leftNav li.updatesItem a.articleTitle').text.delete('^a-zA-Z0-9').length.should > 0
    end
    
    it "should return the same articles the API returns"
    
    it "should display ten articles" do
      @doc.css('div.leftNav li.updatesItem a.articleTitle').count.should == 10
      @doc.css('div.leftNav li.updatesItem').each do |article|
        article.css('a.articleTitle').text.delete('^a-zA-Z0-9').length.should > 0
      end
    end
    
    it "should link to an article page for each story headline" do
      @doc.css('div.leftNav li.updatesItem a.articleTitle').each do |article_title|
        article_title.attribute('href').to_s.match(/\/articles\//)
      end
    end
    
    it "should display the comment field for each article" do
      @doc.css('div.leftNav li.updatesItem a.articleCommentCount').each do |comment_field|
        comment_field.text.match(/Comments/).should be_true
      end
    end
    
    it "should link to an article page for each comment count" do
      @doc.css('div.leftNav li.updatesItem a.articleCommentCount').each do |comment_count|
        comment_count.attribute('href').to_s.match(/\/articles\//)
      end
    end
    
    it "should display a date for each article" do
      @doc.css('div.leftNav li.updatesItem p.articleDate').each do |article_date|
        article_date.text.match(/\A\w{2,}\s\d{1,},\s\d{4}/).should be_true
      end
    end
    
  end
  
  context "Latest Videos" do
    
    it "should be in the right rail" do
      @doc.at_css('div.rightrail-module div.ign-latestVideos').should be_true
    end
    
    it "should display the title 'Latest Videos'" do
      @doc.css('div.ign-latestVideos h2').text.should == 'Latest Videos'
    end
    
    it "should display at least one video thumbnail" do
      @doc.at_css("div.latestVideo img.latestVideo-thumbnail[src*='http']").should be_true
    end
    
    it "should display three video thumbnails" do
      @doc.css("div.latestVideo img.latestVideo-thumbnail[src*='http']").count.should == 3
      @doc.css('div.latestVideo span.latestVideo-image').each do |video|
        video.at_css("img.latestVideo-thumbnail[src*='http']").should be_true
        RestClient.get video.at_css("img.latestVideo-thumbnail").attribute('src').to_s
      end
    end
    
    it "should display a title link for each thumbnail" do
      @doc.css("div.latestVideo img.latestVideo-thumbnail[src*='http']").count.should == @doc.css('div.latestVideo a span.latestVideo-title').count
      @doc.css('div.latestVideo a span.latestVideo-title').text.delete('^a-zA-Z').length.should > 0
    end
    
    it "should link to a video-player page for each video" do
      @doc.css("div.latestVideo a").attribute('href').to_s.match(/ign.com\/videos\/\d{4}\/\d{2}\/\d{2}\/[a-z]/)
    end
        
  end
  
  context "Latest Image" do
    
    it "shoud be in the right rail" do
      @doc.at_css('div.rightrail-module div.ign-latestImages').should be_true
    end
    
    it "should display the title 'Latest Image'" do
      @doc.css('div.ign-latestImages h2').text.should == 'Latest Image'
    end
    
    it "should display an image" do
      RestClient.get @doc.css('div.latestImage a img').attribute('src').to_s
    end
    
    it "should display a date for the image" do
      @doc.css('div.ign-latestImages span.latestImage-date').text.match(/\A\w{2,}\s\d{1,},\s\d{4}/).should be_true
    end
    
  end
    
end

####################################################################################

describe "Unreleased GOB Page -- /games/halo-4/xbox-360-110563" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/games/halo-4/xbox-360-110563"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  common_gob_checks
  
end

####################################################################################
=begin
describe "Popular GOB Page -- ????????????????" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}????????????????"
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end

    common_gob_checks
  
end
=end
