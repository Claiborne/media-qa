module LegacyBlogroll
  
  require 'fe_checker'
  include FeChecker

  def widget_legacy_blogroll_smoke
    it "should not be missing from the page", :smoke => true do
       @doc.css('div#all-news').should be_true
    end
  end
  
  def widget_legacy_blogroll
    
    widget_legacy_blogroll_smoke
     
    it "should be on the page once", :smoke => true do
      @doc.css('div#all-news').count.should == 1
    end
    
    it "should display text", :smoke => true do
       check_display_text('div#all-news > div.headlines')
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('div#all-news div.headlines')
    end

    it "should have at least one image", :smoke => true do
       check_have_an_img('div#all-news div.headlines')
    end
    
    it "should populate 12 entires", :smoke => true do
      @doc.css('div#all-news > div.headlines').count.should == 12
    end
    
  end
end