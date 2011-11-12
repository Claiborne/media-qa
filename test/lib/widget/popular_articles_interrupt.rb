module PopularArticlesInterrupt
  
  require 'link_checker'
  include LinkChecker
  
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
    
    it "should not contain any broken links", :spam => true do
      check_for_broken_links('div.popularArticles')
    end
    
    it "should contain links that only return a response code of 200", :spam => true do
      check_links_200('div.popularArticles')
    end

  end 
end