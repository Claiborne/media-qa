module MostCommentedStories
  
  require 'fe_checker'
  include FeChecker
  
  def widget_most_commented_stories_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.mostCommented').should be_true
    end
  end
  
  def widget_most_commented_stories
    
    widget_most_commented_stories_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css('div.mostCommented').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.mostCommented')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div.mostCommented')
    end
    
    it "should display text in the header", :smoke => true do
      check_display_text('div.mostCommented div.mostCommented-header')
    end
    
    #it "should have six articles" do
      #@doc.css('div.mostCommented ul li').count.should == 6
    #end

    it "should have at least five articles" do
      @doc.css('div.mostCommented ul li').count.should > 4
    end
    
    it "should have a link for each article", :smoke => true do
      check_have_a_link_for_each('div.mostCommented ul li')
    end
    
    it "should display text for each article", :smoke => true do
      check_display_text_for_each('div.mostCommented ul li > a')
    end
    
  end 
end