module Blogrollv2Articles
#spec file requires Nokogiri, rspec, rest_client, and json

  def check_not_blank(doc, num, element)
    i = 0
    doc.css(element).each do |element_instance|
      if element_instance.text.delete("^a-zA-Z").length <  1
        i = i+1
      end
    end
    doc.css(element).count.should > 0
    i.should be < num*0.7
  end
  
  def widget_blogroll_v2_articles(num, call)

    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div#ign-blogroll').should be_true
    end
    
    it "should be on the page only once" do
      @doc.css('div#ign-blogroll').count.should == 1
    end
  
    it "should have #{num} blogroll entries" do
      @doc.css('div#ign-blogroll div.listElmnt-articleContent').count.should eql(num)
    end

    it "shoud display the authors' names" do
      check_not_blank(@doc, num, "div#ign-blogroll div.listElmnt-authors")
    end
    
    it "shoud display the articles' timestamps" do
      check_not_blank(@doc, num, "div#ign-blogroll div.listElmnt-date")
    end

    it "shoud display the articles' headlines", :code => true do
      check_not_blank(@doc, num, "div#ign-blogroll a.listElmnt-storyHeadline")
    end

    it "shoud display articles' summaries", :code => true do
      check_not_blank(@doc, num, "div#ign-blogroll p.listElmnt-summary")
    end
    
    it "shoud display the read more links" do
      check_not_blank(@doc, num, "div#ign-blogroll a.moreLink")
    end

    it "should display only unique entries", :code => true do
      headline = []
      @doc.css('div.listElmnt-articleContent a.listElmnt-storyHeadline').each do |entry|
        headline << entry.attribute('href')
      end
      headline.count.should > 0
      headline.count.should eql(headline.uniq.count)
    end

    it "should display the same articles as the api returns" do
      Configuration.config_path = File.dirname(__FILE__) + "/../../config/v2.yml"
      config = Configuration.new
    
      data = JSON.parse((rest_client_open("http://#{config.options['baseurl']}#{call}")).body)
      api_titles = []
      data.each do |article|
        api_titles << article['blogroll']['headline']
      end

      frontend_titles = []
      @doc.css("div#ign-blogroll a.listElmnt-storyHeadline").each do |article|
        frontend_titles << article.text
      end
      titles = api_titles + frontend_titles
      titles.uniq.count.should be <= num+2
    end

  end
end