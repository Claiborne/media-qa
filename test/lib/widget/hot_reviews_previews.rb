module HotReviewsPreviews

  require 'fe_checker'
  include FeChecker
  
  def widget_hot_reviews_previews_smoke(type_of_news)
    it "should not be missing from the page", :smoke => true do
      @doc.at_css("div#ign-#{type_of_news}").should be_true
    end
  end
  
  def widget_hot_reviews_previews(type_of_news, num_of_slots)
    
   widget_hot_reviews_previews_smoke(type_of_news)
    
    it "should be on the page once", :smoke => true do
      @doc.css("div#ign-#{type_of_news}").count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text("div#ign-#{type_of_news}")
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link("div#ign-#{type_of_news}")
    end
    
    it "should have at least #{num_of_slots} slots", :smoke => true do
      actual_slots = 0
      @doc.css("div#ign-#{type_of_news} ul li").each do |li|
        if li.attribute('class').to_s != 'last'; actual_slots += 1 end
      end
      actual_slots.should >= num_of_slots
    end
    
    it "should have text in each slot", :smoke => true do
      check_display_text_for_each("div#ign-#{type_of_news} ul li")
    end
    
    it "should have a link in each slot", :smoke => true do
      check_have_a_link_for_each("div#ign-#{type_of_news} ul li")
    end
    
  end
end