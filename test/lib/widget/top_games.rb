module TopGames
  
  require 'fe_checker'
  include FeChecker
  
  def widget_top_games_smoke(type)
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.promo_entertainment_container').should be_true
    end
  end
  
  def widget_top_games(type)
    
    widget_top_games_smoke(type)

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