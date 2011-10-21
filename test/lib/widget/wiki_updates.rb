module WikiUpdates
  
  def widget_wiki_updates
    
    it "should not be missing from the page", :code => true do
      @doc.at_css('div.wikiUpdates').should be_true
    end
    
    #####if @doc.at_css('div.wikiUpdates').should do
    
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