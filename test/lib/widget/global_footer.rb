module GlobalFooter
  
  require 'fe_checker'
  include FeChecker
  
  def widget_global_footer_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.ignFooter-content').should be_true
    end
  end
  
  def widget_global_footer
    
    widget_global_footer_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css('div.ignFooter-content').count.should == 1
    end
    
    it "should display text", :smoke => true do
       check_display_text('div.ignFooter-content')
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('div.ignFooter-content')
    end

    it "should have at least one image", :smoke => true do
       check_have_an_img('div.ignFooter-content')
    end
    
  end 
end