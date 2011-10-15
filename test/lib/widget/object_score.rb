module ObjectScore
  
  def widget_object_score
    
    it "should not be missing from the page if an article has a review score" do
      @doc.at_css('div.ratingScoreBoxContainer div.ratingScoreBox').should be_true
    end
    
    it "should only appear once if an article has a review score" do
      @doc.css('div.ratingScoreBoxContainer div.ratingScoreBox').should == 1
    end
    
    it "should not appear on an article with no review score" do
      @doc.css('div.ratingScoreBoxContainer div.ratingScoreBox').should == 1
    end

  end 
end