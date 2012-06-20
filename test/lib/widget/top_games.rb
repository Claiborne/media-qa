module TopGames
  
  require 'fe_checker'
  include FeChecker
  
  def widget_top_games_smoke(type)
    it "should not be missing from the page", :smoke => true do
      return_top_games_widget(@doc, type).should be_true
      @doc.at_css('div.right-col-module div.topgames-module').should be_true
    end
  end
  
  def widget_top_games(type, num_of_slots)
    
    widget_top_games_smoke(type)

    it "should be on the page once", :smoke => true do
      return_top_games_widget(@doc, type).count.should == 1
    end
    
    it "should display text", :smoke => true do
      return_top_games_widget(@doc, type).text.delete("^a-zA-Z").length.should > 0
    end

    it "should have at least one link", :smoke => true do
     return_top_games_widget(@doc, type).css("a[href*='http']").count.should > 0
    end
    
    it "should not have any broken links", :spam => true do
      return_top_games_widget(@doc, type).css('a').each do |link|
        RestClient.get link.attribute('href').to_s
      end
    end
    
    it "should have at least #{num_of_slots} slots", :smoke => true do
      return_top_games_widget(@doc, type).css('div.column-game').count.should >= num_of_slots
    end
    
    it "should have text in each slot", :smoke => true do
      return_top_games_widget(@doc, type).css('div.column-game div.game-details').each do |slot|
        slot.text.delete("^a-zA-Z").length.should > 0
      end
    end
    
    it "should have a link in each slot", :smoke => true do
      return_top_games_widget(@doc, type).css('div.column-game divgame-details').each do |slot|
        slot.css("a[href*='http']").count.should > 0
      end
    end
    
    it "should display a number in each slot" do
      return_top_games_widget(@doc, type).css('div.column-game div.list-count').each do |slot|
        slot.text.delete("^0-9").length.should > 0
      end
    end
    
    it "should link to an object page when a game's title is clicked" do
      return_top_games_widget(@doc, type).css('div.column-game a.game-title').each do |slot|
        slot.attribute('href').to_s.match(/.com\/games/).should be_true
      end
    end
    
  end #end module
  
  def return_top_games_widget(doc, text)
    doc.css("div.right-col-module").each do |mod|
      if mod.css('div.subHeaderSectionContainer').text.match(/#{text}/); return mod; end
    end
    return false
  end
  
end