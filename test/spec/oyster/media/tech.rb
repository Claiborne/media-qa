require 'rspec'
require 'configuration'
require 'nokogiri'
require 'open-uri'
require 'tech_nav'
require 'rest_client'
require 'json'
require 'open_page'
require 'fe_checker'
require 'widget/blogroll_v2_articles'
require 'widget/discover_more'
require 'widget/cover_stories_main'
require 'widget/cover_stories_extra'
require 'widget/tag_cover_stories'
require 'widget/vert_nav'
require 'widget/wiki_updates'
require 'widget/video_interrupt'
require 'widget/popular_articles_interrupt'
require 'widget/object_score'
require 'widget/global_header'
require 'widget/global_footer'

include GlobalFooter
include GlobalHeader
include FeChecker
include ObjectScore
include PopularArticlesInterrupt
include VideoInterrupt
include OpenPage
include VertNav
include CoverStoriesMain
include CoverStoriesExtra
include TagCoverStories
include TechNav
include Blogrollv2Articles
include DiscoverMore
include WikiUpdates

describe "Tech HomePage:" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech"
    @doc = nokogiri_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should return 200", :smoke => true do
    check_return_200_without_301(@page)
  end

  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end

  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end
  
  context "Global Header Widget:" do
    widget_global_header
  end
  
  context "Global Footer Widget:" do
    widget_global_footer
  end
  
  it "should include the follow us widget once" do
    @doc.css('div.followBox').count.should == 1
  end
  
  context "Tech Nav Widget:" do
    wiget_discover_more_expanded
  end
  
  context "Main Cover Stories Widget:" do
    widget_cover_stories_main
  end
  
  context "Extra Cover Stories Widget:" do
    widget_cover_stories_extra
  end

  context "Blogroll Widget:" do
    widget_blogroll_v2_articles(10, "/v2/articles.json?post_type=article&page=1&per_page=10&categories=tech&sort=publish_date&order=desc")
    
    it "should include the load more button ocne" do
      @doc.css('div.blogrollv2Container button#loadMore').count.should == 1
    end
    
    it "should include a functional load more button", :test => true do
      @doc.css('div.blogrollv2Container button#loadMore').attribute('data-url').to_s.match(/http:\/\/widgets.ign.com\/global\/page\/blogrollv2articles.jsonp\?post_type=article&page=2&per_page=10&categories=tech/).should be_true
    end
  end
  
  context "Video Interrupt Widget:" do
    widget_video_interrupt
  end
  
  context "Popular Article Interrupt Widget:" do
    widget_popular_articles_interrupt
  end

end

@topic = return_tech_nav
@topic.each do |topic|
  
describe "Tech #{topic} Topic Page:" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech/#{topic}"
    @doc = nokogiri_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should return 200", :smoke => true do
    check_return_200_without_301(@page)
  end

  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end     
  
  context "Global Header Widget:" do
    widget_global_header
  end
  
  context "Global Footer Widget:" do
    widget_global_footer
  end
  
  it "should include the follow us widget once" do
    @doc.css('div.followBox').count.should == 1
  end
  
  it "should include the article submission widget once" do
    @doc.css('a.postNews').count.should == 1
  end
    
  context "Blogroll Widget:" do
    widget_blogroll_v2_articles(20, "/v2/articles.json?post_type=article&page=1&per_page=20&categories=tech&tags=#{topic}&sort=publish_date&order=desc")
  end
  
  context "Vertical Navigation Widget:" do
    widget_vert_nav("tech", topic)
  end

  if topic == "lifestyle"
    context "Tag Cover Stories Widget:" do
      it "should check when implemented on FE"
    end
  else
    context "Tag Cover Stories Widget:" do
      widget_tag_cover_stories
    end
  end

  context "Discover More Widget:" do
    widget_discover_more
  end

  if topic != 'lifestyle'
    context "Wiki Updates Widget:" do
      widget_wiki_updates
    end
  end

end
end

describe "Tech v2 Article Page:" do
  
  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/tech.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/articles/2011/09/21/gears-of-war-3-dolby-7-1-surround-sound-headset-review"
    @doc = nokogiri_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should return 200", :smoke => true do
    check_return_200_without_301_to_home(@page)
  end

  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end  
  
  it "should display the author's name" do
    @doc.at_css('div.article_byLine div.article_author').text.delete('^a-zA-Z').length.should > 2
  end
  
  context "Global Header Widget:" do
    widget_global_header
  end
  
  context "Global Footer Widget:" do
    widget_global_footer
  end
  
  it "should include two share this widgets" do
    (@doc.css("div[class*='addthis_toolbox']").count == 2).should be_true
  end
  
  it "should include the discus comments widget once", :smoke => true do
    @doc.css('div#disqus_thread').count.should == 1
  end
  
  widget_wiki_updates_smoke

  it "should not display the pagination widget when only one page exists" do
    @doc.at_css('div.pager_list').should be_false
  end
  
  widget_discover_more_smoke
  
  widget_video_interrupt_smoke
  
  context "Vert Nav Widget:" do
    
    widget_discover_more_smoke
    
    it "should include all components", :smoke => true do
      @doc.at_css('div.vn-container ul li.vn-follow').should be_true
      @doc.at_css('div.vn-container ul li.vn-categoryItem a').should be_true
      @doc.css('div.vn-container ul li.vn-navItem a').count.should > 3
    end
  end
  
  context "Object Scorebox Widget:" do
    widget_object_score
  end
  
  it "should not display the object score box widget when no review score exists" do
    page2 = "http://#{@config.options['baseurl']}/articles/2011/10/24/apple-upgrades-macbook-pro-line"
    doc2 = nokogiri_open(page2)
    doc2.css('div.ratingScoreBoxContainer div.ratingScoreBox').count.should == 0
  end
  
end