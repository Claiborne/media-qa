module WhatWeArePlaying

  require 'fe_checker'
  include FeChecker
  
  def widget_what_we_are_playing_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.statusUpdateList').should be_true
    end
  end
  
  def widget_what_we_are_playing
    
    widget_what_we_are_playing_smoke
    
    it "should be on the page once", :smoke => true do
      @doc.css('div.statusUpdateList').count.should == 1
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.statusUpdateList')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div.statusUpdateList')
    end
    
    it "should have at least one image", :smoke => true do
      check_have_an_img('div.statusUpdateList')
    end
    
  end
end