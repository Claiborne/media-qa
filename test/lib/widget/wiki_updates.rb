module WikiUpdates
  
  def widget_wiki_updates
    
    it "should not be missing from the page", :stg => true do
      @doc.at_css('div.wikiUpdates').should be_true
    end
    
    it "should contain links to recently updated Wiki pages", :stg => true do
      @doc.css("div.wikiUpdates ul a.itemLink[href*='/wikis/']").count.should > 0
    end
    
    it "should display link text to recently updated Wiki pages", :stg => true do
      link_text = ""
      @doc.css('div.wikiUpdates ul a.itemLink').each do |a|
        link_text << a.text.delete('^a-zA-Z0-9')
      end
      link_text.length.should > 0
    end
    
  end 
end