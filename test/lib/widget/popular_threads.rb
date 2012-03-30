module PopularThreads

  require 'fe_checker'
  include FeChecker
  
  def widget_popular_threads_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css("div.popularthreads_link").should be_true
    end
  end
  
  def widget_popular_threads
    
   widget_popular_threads_smoke
    
    it "should display text", :smoke => true do
      check_display_text("div.popularthreads_link")
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link("div.popularthreads_link")
    end
    
    it "should have five threads", :smoke => true do
      @doc.css("div.popularthreads_link").count.should == 5
    end
    
    it "should display text for each thread", :smoke => true do
      check_display_text_for_each("div.popularthreads_link")
    end
    
    it "should have a link for each thread", :smoke => true do
      check_have_a_link_for_each("div.popularthreads_link")
    end
    
  end
  
end