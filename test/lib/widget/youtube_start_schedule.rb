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
    
    it "should display text in the header" do
      check_display_text("div#startWidget div#startHeader")
    end
    
    it "should have at least one link in the header" do
      check_have_a_link("div#startWidget div#startHeader")
    end
    
    it "should have at least one image in the header" do
      check_have_an_img("div#startWidget div#startHeader")
    end
    
    it "should display text in the content area" do
      check_display_text("div#startWidget div#startCurrentShow")
    end
    
    it "should have at least one link in the content area" do
      check_have_a_link("div#startWidget div#startCurrentShow")
    end
    
    it "should have at least one image in the content area" do
      check_have_an_img("div#startWidget div#startCurrentShow")
    end
    
    it "should display text in the schedule area" do
      check_display_text("div#startWidget div#startUpcomingShows")
    end
    
    it "should have at least one link in the schedule area" do
      check_have_a_link("div#startWidget div#startUpcomingShows")
    end
    
    it "should have at least four shows in the schedule" do
      @doc.css("div#startWidget div#startUpcomingShows div.startUpcomingShow").count.should > 3
    end
    
    it "should display text for each schedule listing" do
      check_display_text_for_each("div#startWidget div#startUpcomingShows div.startUpcomingShow")
    end
    
    it "should have at least one link for each schedule listing" do
      check_have_a_link_for_each("div#startWidget div#startUpcomingShows div.startUpcomingShow")
    end
    
  end
  
end