module ObjectScore
  
  def widget_object_score
    
    it "should not be missing from the page", :stg => true do
      @doc.at_css('div.ratingScoreBoxContainer div.ratingScoreBox').should be_true
    end

  end 
end