module VideoHubSlotter
  
  require 'fe_checker'
  include FeChecker

  def widget_video_hub_slotter_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('ul#video-hub').count.should == 1
    end
  end
  
  def widget_video_hub_slotter
    
    widget_video_hub_slotter_smoke
     
    it "should not be missing from the page", :smoke => true do
       @doc.css('ul#video-hub').should be_true
    end
    
    it "should display text", :smoke => true do
       check_display_text('ul#video-hub')
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('ul#video-hub')
    end

    it "should have at least one image", :smoke => true do
       check_have_an_img('ul#video-hub')
    end
    
    it "should have three slots and three links", :smoke => true do
      @doc.css('ul#video-hub div.grid_8').count.should == 3
    end
    
    it "should have three links", :smoke => true do
      @doc.css("ul#video-hub div.grid_8 a[href*='http']").count.should == 3
    end
    
    it "should have three images", :smoke => true do
      @doc.css("ul#video-hub div.grid_8 img[src*='http']").count.should == 3
    end
    
    it "should contain links that only return a 200", :smoke => true do
      check_links_not_301_home("ul#video-hub div.grid_8")
    end
    
  end
end