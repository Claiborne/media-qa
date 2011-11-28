module PopularArticlesInterrupt
  
  require 'fe_checker'
  include FeChecker
  
  def widget_popular_articles_interrupt_smoke
    it "should be on the page only once", :smoke => true do
      @doc.css('div.popularArticles').count.should == 1
    end
  end
  
  def widget_popular_articles_interrupt
    
    widget_popular_articles_interrupt_smoke
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.popularArticles').should be_true
    end
    
    it "should display text", :smoke => true do
      check_display_text('div.popularArticles')
    end

    it "should have at least one link", :smoke => true do
      check_have_a_link('div.popularArticles')
    end
    
    it "should not be blank", :smoke => true do
      headlines = ""
      @doc.css('div.popularArticles ul li a:nth-child(1)').each do |a|
        if !a.attribute('href').to_s.match(/#disqus_thread/)
          headlines << a.text
        end
      end
      headlines.delete("^a-zA-Z").length.should > 0
    end
    
    it "should dispay a title" do
      @doc.at_css('div.popularArticles h2.popularArticlesHeader').text.delete("^a-zA-Z").length.should > 0
    end
    
    it "should contain at least three slots for articles", :smoke => true do
      @doc.css('div.popularArticles ul li').count.should > 2
    end
    
    it "should display article headlines for each" do
      @doc.css('div.popularArticles ul li a:nth-child(1)').each do |a|
        if !a.attribute('href').to_s.match(/#disqus_thread/)
          a.text.delete("^a-zA-Z").length.should > 0
        else
          false.should be_true
        end
      end
    end
    
    it "should contain links that only return a 200", :spam => true do
      check_links_not_301_home('div.popularArticles')
    end
    
  end 
end