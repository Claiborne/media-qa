require 'rspec'
require 'configuration'
require 'nokogiri'
require 'tech_nav'
require 'rest_client'
require 'json'
require 'open_page'
require 'fe_checker'
require 'widget/blogroll_v3_articles'
require 'widget/discover_more'
require 'widget/tag_cover_stories'
require 'widget/vert_nav'
require 'widget/wiki_updates'
require 'widget/object_score'
require 'widget/evo_header'
require 'widget/global_footer'

include GlobalFooter
include EvoHeader
include FeChecker
include ObjectScore
include OpenPage
include VertNav
include TagCoverStories
include TechNav
include Blogrollv3Articles
include DiscoverMore
include WikiUpdates

@topic = return_tech_nav
@topic.each do |topic|
  
describe "Tech #{topic} Topic Page" do

  before(:all) do
    Configuration.config_path = File.dirname(__FILE__) + "/../../../config/oyster/oyster_media.yml"
    @config = Configuration.new
    @page = "http://#{@config.options['baseurl']}/tech/#{topic}"
    puts @page
    @doc = nokogiri_not_301_open(@page)
  end

  before(:each) do
    
  end

  after(:each) do

  end
  
  it "should return 200", :smoke => true do
  end

  it "should include at least one css file", :smoke => true do
    check_include_at_least_one_css_file(@doc)
  end
  
  it "should not include any css files that return 400 or 500", :smoke => true do
    check_css_files(@doc)
  end     
  
  context "Global Header Widget:" do
    widget_evo_header
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
    
  context "Blogroll Widget" do
    widget_blogroll_v3_articles(20, "n/a")
  end
  
  context "Vertical Navigation Widget" do
    widget_vert_nav("tech", topic)
  end

  if topic == "lifestyle"
  else
    context "Tag Cover Stories Widget" do
      widget_tag_cover_stories
    end
  end

  context "Discover More Widget" do
    widget_discover_more
  end

  if topic != 'lifestyle'
    context "Wiki Updates Widget" do
      widget_wiki_updates
    end
  end

end
end