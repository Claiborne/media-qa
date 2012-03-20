module LegacyCoverStories
  
  require 'fe_checker'
  include FeChecker

  def widget_legacy_cover_stories_smoke
    it "should not be missing from the page", :smoke => true do
       @doc.at_ss('div.coverStories').should be_true
    end
  end
  
  def widget_legacy_cover_stories
    
    widget_legacy_cover_stories_smoke
     
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
    
    it "should not be missing the main display", :smoke => true do
      @doc.css('div.coverStories div.cvr-main').should be_true
    end
    
    it "should not be missing the highlights display", :smoke => true do
      @doc.css('div.coverStories cvr-highlights').should be_true
    end
    
    it "should not be missing the thumbnail nav", :smoke => true do
      @doc.css('div.coverStories div.cvr.nav').should be_true
    end
    
  end
end