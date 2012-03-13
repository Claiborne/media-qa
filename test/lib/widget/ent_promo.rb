module EntPromo
  
  require 'fe_checker'
  include FeChecker
  
  def widget_ent_promo_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.promo_entertainment_container').should be_true
    end
  end
  
  def widget_ent_promo
    
    widget_ent_promo_smoke

    it "should be on the page once", :smoke => true do
      @doc.css('div.promo_entertainment_container').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.promo_entertainment_container')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div.promo_entertainment_container')
    end
  end
  
end