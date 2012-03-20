module TopGames
  
  require 'fe_checker'
  include FeChecker
  
  def widget_top_games_smoke(type)
    it "should not be missing from the page", :smoke => true do
      return_top_games_widget(@doc, type).should be_true
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
    
    it "should have #{num_of_slots} slots", :smoke => true do
      return_top_games_widget(@doc, type).css('div.column-game').count.should == num_of_slots
    end
    
    it "should have text in each slot", :smoke => true do
      return_top_games_widget(@doc, type).css('div.column-game').each do |slot|
        slot.text.delete("^a-zA-Z").length.should > 0
      end
    end
    
    it "should have a link in each slot", :smoke => true do
      return_top_games_widget(@doc, type).css('div.column-game').each do |slot|
        slot.css("a[href*='http']").count.should > 0
      end
    end
    
    it "should have an image in each slot" do
      return_top_games_widget(@doc, type).css('div.column-game').each do |slot|
        slot.css("img[src*='http']").count.should > 0
      end
    end
    
    it "should link to an object page when a game's box-art is clicked" do
      return_top_games_widget(@doc, type).css('div.column-game div.boxart a').each do |slot|
        slot.attribute('href').to_s.match(/.com\/object/).should be_true
      end
    end
    
    it "should link to an object page when a game's title is clicked" do
      return_top_games_widget(@doc, type).css('div.column-game a.game-title').each do |slot|
        slot.attribute('href').to_s.match(/.com\/object/).should be_true
      end
    end
    
    it "should have a platform filter present" do
      return_top_games_widget(@doc, type).at_css('ul.platform-filters li a').should be_true
      return_top_games_widget(@doc, type).at_css('ul.platform-filters li').text.delete("^a-zA-Z0-9").length.should > 0
    end
    
    it "should display platform-specific games when the platform filters are clicked" do
      return_top_games_widget(@doc, type).css('ul.platform-filters li a').each do |li|
        platform = li.css("a").text.delete("^a-zA-Z0-9").downcase
        begin
          li.attribute('onclick').to_s.match(/#{platform}/).should be_true
        rescue => e
          raise Exception.new("#{e.message}. #{li.attribute('onclick')} != #{platform}")
        end
      end#end filter loop
    end
    
  end
  
  def return_top_games_widget(doc, text)
    doc.css("div.right-col-module").each do |mod|
      if mod.text.match(/#{text}/); return mod; end
    end
    return false
  end
  
end