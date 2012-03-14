module YoutubeStartSchedule
  
  require 'fe_checker'
  include FeChecker
  
  def widget_youtube_start_schedule_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css("div#startWidget").should be_true
    end
  end
  
  def widget_youtube_start_schedule
    
   widget_youtube_start_schedule_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css("div#startWidget").count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text("div#startWidget")
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link("div#startWidget")
    end
    
    it "should have at least one image", :smoke => true do
      check_have_an_img("div#startWidget")
    end
  end
  
end