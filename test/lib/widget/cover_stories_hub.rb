module CoverStoriesHub
  
  require 'fe_checker'
  include FeChecker
  
  def widget_cover_stories_hub_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.coverStories').should be_true
    end
  end
  
  def widget_cover_stories_hub
    
    widget_cover_stories_hub_smoke

    it "should be on the page once", :smoke => true do
      @doc.css('div.coverStories').count.should == 1
    end
    
    it "should display text", :smoke => true do
       check_display_text('div.coverStories')
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('div.coverStories')
    end
    
    it "should have at least one image", :smoke => true do
      check_have_an_img('div.coverStories')
    end

    it "should not have any broken images", :spam => true do
      check_for_broken_images('div.coverStories')
    end

    it "should contain links that only return a 200"#, :spam => true do
      #check_links_not_301_home('div.coverStories')
    #end

  end
end