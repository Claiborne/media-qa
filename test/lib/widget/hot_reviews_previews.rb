module HotReviewsPreviews

  require 'fe_checker'
  include FeChecker
  
  def widget_hot_reviews_previews_smoke(type)
    it "should not be missing from the page", :smoke => true do
      @doc.at_css("div#ign-#{type}").should be_true
    end
  end
  
  def widget_hot_reviews_previews(type)
    
   widget_hot_reviews_previews_smoke(type)
    
    it "should be on the page once", :smoke => true do
      @doc.css("div#ign-#{type}").count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text("div#ign-#{type}")
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link("div#ign-#{type}")
    end
    
  end
end