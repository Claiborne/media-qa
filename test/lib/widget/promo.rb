module Promo

  require 'fe_checker'
  include FeChecker
  
  def widget_promo_smoke(type)
    it "should not be missing from the page", :smoke => true do
      @doc.at_css("div.promo_#{type}_container").should be_true
    end
  end
  
  def widget_promo(type)
    
   widget_promo_smoke(type)
    
    it "should be on the page once", :smoke => true do
      @doc.css("div.promo_#{type}_container").count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text("div.promo_#{type}_container")
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link("div.promo_#{type}_container")
    end
    
    it "should have at least one image", :smoke => true do
      check_have_an_img("div.promo_#{type}_container")
    end
    
  end
end