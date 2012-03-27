module Promo

  require 'fe_checker'
  include FeChecker
  
  def widget_promo_smoke(type_of_promo)
    it "should not be missing from the page", :smoke => true do
      @doc.at_css("div.promo_#{type_of_promo}_container").should be_true
    end
  end
  
  def widget_promo(type_of_promo, num_of_slots)
    
   widget_promo_smoke(type_of_promo)
    
    it "should be on the page once", :smoke => true do
      @doc.css("div.promo_#{type_of_promo}_container").count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text("div.promo_#{type_of_promo}_container")
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link("div.promo_#{type_of_promo}_container")
    end
    
    it "should have at least one image", :smoke => true do
      check_have_an_img("div.promo_#{type_of_promo}_container")
    end
    
    it "should have #{num_of_slots} slots", :smoke => true do
      @doc.css("div.promo_#{type_of_promo}_container div.promo_#{type_of_promo}_item").count.should == num_of_slots
    end
    
    it "should have text in each slot", :smoke => true do
      check_display_text_for_each("div.promo_#{type_of_promo}_container div.promo_#{type_of_promo}_item")
    end
    
    it "should have a link in each slot", :smoke => true do
      check_have_a_link_for_each("div.promo_#{type_of_promo}_container div.promo_#{type_of_promo}_item")
    end
    
    it "images should be clickable"
  end
  
end