module ObjectScore
  
  require 'fe_checker'
  include FeChecker
  
  def widget_object_score_smoke
    it "should not be missing from the page", :smoke => true do
       @doc.at_css('div.ratingScoreBoxContainer div.ratingScoreBox').should be_true
    end
  end
  
  def widget_object_score
    
    widget_object_score_smoke
    
    it "should be on the page only once if an article has a review score", :smoke => true do
      @doc.css('div.ratingScoreBoxContainer div.ratingScoreBox').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.ratingScoreBoxContainer div.ratingScoreBox')
    end
    
    it "should not be missing from a article has a review score", :smoke => true do
      @doc.at_css('div.ratingScoreBoxContainer div.ratingScoreBox').should be_true
    end
    
    it "should display a text score" do
      @doc.at_css('div.ratingScoreBoxContainer div.rsb-scoreText').text.delete('^a-zA-Z').length.should > 0
    end
    
    it "should display a numberic score", :smoke => true do
      @doc.at_css('div.ratingScoreBoxContainer div.rsb-scoreNumber').text.delete('^0-9').length.should > 0
    end

  end 
end