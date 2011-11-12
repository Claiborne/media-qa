module WikiUpdates
  
  def widget_wiki_updates_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.wikiUpdates').count.should == 1
    end
  end
  
  def widget_wiki_updates
    
    widget_wiki_updates_smoke
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.wikiUpdates').should be_true
    end
    
    it "should contain links to recently updated Wiki pages" do
      @doc.css("div.wikiUpdates ul a.itemLink[href*='/wikis/']").count.should > 0
    end
    
    it "should display link text to recently updated Wiki pages" do
      link_text = ""
      @doc.css('div.wikiUpdates ul a.itemLink').each do |a|
        link_text << a.text.delete('^a-zA-Z0-9')
      end
      link_text.length.should > 0
    end
    
  end 
end