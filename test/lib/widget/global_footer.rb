module GlobalFooter
  
  def widget_global_footer_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.ignFooter-content').count.should == 1
    end
  end
  
  def widget_global_footer
    
    widget_global_footer_smoke
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.ignFooter-content').should be_true
    end
    
  end 
end