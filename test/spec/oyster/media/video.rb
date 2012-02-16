require 'rspec'
require 'nokogiri'
require 'rest_client'
require 'open_page'
require 'fe_checker'
require 'widget/global_header'
require 'widget/global_footer'
require 'widget/video_hub_slotter'

include FeChecker
include OpenPage
include GlobalFooter
include GlobalHeader
include VideoHubSlotter

  # Helper Method #

def check_video_blogroll

  it "should not be missing from the page", :smoke => true do
    @doc.css('div#video-blogroll').should be_true
  end

  it "should populate 15 entires", :smoke => true do
    @doc.css("div#video-blogroll div[class='grid_16 alpha bottom_2']").count.should == 15
  end

  it "should display text", :smoke => true do
    check_display_text("div#video-blogroll div[class='grid_16 alpha bottom_2']")
  end

  it "should have at least one link", :smoke => true do
    check_have_a_link("div#video-blogroll div[class='grid_16 alpha bottom_2']")
  end

  it "should have at least one image", :smoke => true do
    check_have_an_img("div#video-blogroll div[class='grid_16 alpha bottom_2']")
  end

  it "should display a load more button", :smoke => true do
    @doc.css('div#video-blogroll a#moreVideos').should be_true
  end

  it "should display a functional load more button" do
    @doc.css('div#video-blogroll a#moreVideos').attribute('href')
  end

end

  # Tests #

describe "Video Hub:" do

  before(:all) do
    @page = "http://www.ign.com/videos"
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
    widget_global_header
  end
  
  context "Global Footer Widget:" do
    widget_global_footer
  end
  
  context "Top Video-Slotter" do
    widget_video_hub_slotter
  end

  context "Blogroll" do
    check_video_blogroll
  end
  
end

@blogroll_ajax_calls = [
"http://www.ign.com/videos/all/filtergalleryajax?filter=all",
"http://www.ign.com/videos/all/filtergalleryajax?filter=games-trailer",
"http://www.ign.com/videos/all/filtergalleryajax?filter=games-review",
"http://www.ign.com/videos/all/filtergalleryajax?filter=movies-trailer",
"http://www.ign.com/videos/all/filtergalleryajax?filter=series"
]

@blogroll_ajax_calls.each do |blogroll_call|
  
describe "Video Hub Ajax Calls:" do
  
  before(:all) do
     @page = blogroll_call.to_s
     puts @page
     @doc = nokogiri_not_301_open(@page)
   end

   before(:each) do

   end

   after(:each) do

   end

   it "should return 200", :smoke => true do
   end
   
   it "should return 15 blogroll entries", :smoke => true do
     @doc.css("div[class='grid_16 alpha bottom_2']").count.should == 15
   end
   
   it "should display text", :smoke => true do
     check_display_text("div[class='grid_16 alpha bottom_2']")
   end

   it "should have at least one link", :smoke => true do
     check_have_a_link("div[class='grid_16 alpha bottom_2']")
   end

   it "should have at least one image", :smoke => true do
     check_have_an_img("div[class='grid_16 alpha bottom_2']")
   end

end# end describe
end# end ajax iteration

video_page = nokogiri_open("http://www.ign.com/videos")
@video_player_page = []
video_page.css('ul#video-hub div.grid_8 a').each do |v|
  @video_player_page  << v.attribute('href')
end

@video_player_page.each do |video_player_page|
  
describe "Video Player Page:" do

  before(:all) do
    @page = video_player_page.to_s
    puts @page
    @doc = nokogiri_not_301_open(@page)
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
  
  context "Video Player Header Wrapper:" do
    
    it "should not be missing from the page", :smoke => true do
      @doc.css("div#header-wrapper div").should be_true
    end
    
  end# end context
  
end# end describe
end# end video page iteration