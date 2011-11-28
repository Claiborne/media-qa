module GlobalHeader
  
  def widget_global_header_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div#ign-header').count.should == 1
    end
  end
  
  def widget_global_header
    
    widget_global_header_smoke
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div#ign-header').should be_true
    end
    
  end 
end