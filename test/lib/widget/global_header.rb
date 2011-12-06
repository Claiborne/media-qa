module GlobalHeader
  
  require 'fe_checker'
  include FeChecker
  
  def widget_global_header_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div#ign-header').should be_true
    end
  end
  
  def widget_global_header
    
    widget_global_header_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css('div#ign-header').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div#ign-header')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div#ign-header')
    end
    
  end 
end