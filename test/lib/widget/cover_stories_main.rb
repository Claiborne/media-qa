module CoverStoriesMain
  
  require 'fe_checker'
  include FeChecker
  
  def widget_cover_stories_main_smoke
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.evo-coverStories').should be_true
    end
  end
  
  def widget_cover_stories_main
    
    it "should not be missing from the page", :smoke => true do
      @doc.at_css('div.cat-coverStories').should be_true
    end

    it "should be on the page once", :smoke => true do
      @doc.css('div.cat-coverStories').count.should == 1
    end
    
    it "should display text", :smoke => true do
       check_display_text('div.cat-coverStories')
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('div.cat-coverStories')
    end

    it "should contain three slots for three cover stories" do
      @doc.css('div.cat-coverStories a').count.should == 3
    end

    it "should have an img for each cover story slot" do
      @doc.css('div.cat-coverStories a').each do |a|
        a.attribute('style').to_s.match(/background-image:url/).should be_true
        a.attribute('style').to_s.match(/http/).should be_true
      end
    end

    it "should not have any broken images", :spam => true do
      check_for_broken_images('div.cat-coverStories')
    end

    it "should contain links that only return a 200", :spam => true do
      check_links_not_301_home('div.cat-coverStories')
    end
    
    it "should have three headline spans" do
      @doc.css('div.cat-coverStories span.lcs-headline').count.should == 3
    end

    it "should display a headline for each cover story" do
      @doc.css('div.cat-coverStories span.lcs-headline').each do |headline|
        headline.text.delete("^a-zA-Z").length.should > 0
      end
    end

    it "should display headlines" do
      error_rate = 0
      @doc.css('div.cat-coverStories span.lcs-headline').each do |headline|
        if headline.text.delete("^a-zA-Z").length < 1
          error_rate = error_rate + 1
        end
      end
      error_rate.should < 3
    end

  end
  
  ####################################################
  
  def widget_cover_stories_main_evo(num_of_slots)
    
    widget_cover_stories_main_smoke

    it "should be on the page once", :smoke => true do
      @doc.css('div.evo-coverStories').count.should == 1
    end
    
    it "should display text", :smoke => true do
       check_display_text('div.evo-coverStories')
    end

    it "should have at least one link", :smoke => true do
       check_have_a_link('div.evo-coverStories')
    end
    
    it "should have at least one image", :smoke => true do
      check_have_an_img('div.evo-coverStories')
    end

    it "should not have any broken images", :spam => true do
      check_for_broken_images('div.evo-coverStories')
    end
    
    it "should contain links that only return a 200", :spam => true do
      check_links_not_301_home('div.evo-coverStories')
    end
    
    it "should have one top nav" do
      @doc.css('div.evo-coverStories div.fuseNav').count.should == 1
    end
    
    it "should have #{num_of_slots} links in the top nav" do
      @doc.css('div.evo-coverStories div.fuseNav a').count.should == num_of_slots
    end
    
    it "should display text in each of the nav links" do
      @doc.css('div.evo-coverStories div.fuseNav a').each do |nav_link|
        nav_link.css('span').text.delete("^a-zA-Z").length.should > 0
      end
    end

    it "should have at least #{num_of_slots} slots for #{num_of_slots} cover stories", :smoke => true do
      @doc.css('div.evo-coverStories div.cvr-main').count.should >= num_of_slots
    end
    
    it "should have a clickable image for each cover-story slot", :smoke => true do
      @doc.css("div.evo-coverStories div.cvr-main").each do |story|
        story.css("a > img").count.should == 1
      end
    end
    
    it "should have an http link for each cover-story slot", :smoke => true do
      check_have_a_link_for_each('div.evo-coverStories div.cvr-main')
    end
    
    it "should have an image for each cover-story slot", :smoke => true do
      check_have_an_img_for_each('div.evo-coverStories div.cvr-main')
    end
    
    it "should have at least #{num_of_slots} headlines for #{num_of_slots} cover stories", :smoke => true do
      @doc.css('div.evo-coverStories div.cvr-headline').count.should >= num_of_slots
    end
    
    it "should have a headline for each cover-story slot", :smoke => true do
      @doc.css('div.evo-coverStories div.cvr-headline').count.should == @doc.css('div.evo-coverStories div.cvr-main').count
    end
    
    it "should have a link for the headline in each cover-story slot", :smoke => true do
      check_have_a_link('div.evo-coverStories div.cvr-headline')
    end
    
    it "should display text for each cover-story headline", :smoke => true do
      check_display_text_for_each('div.evo-coverStories div.cvr-headline')
    end
    
    it "should have an http link for each cover-story headline", :smoke => true do
      check_have_a_link_for_each('div.evo-coverStories div.cvr-headline')
    end
    
    it "should have at least #{num_of_slots} subitem slot for #{num_of_slots} cover stories", :smoke => true do
       @doc.css('div.evo-coverStories ul.evo-coverStories-subitems').count.should >= num_of_slots
    end
    
    it "should have a subitem slot for each cover story", :smoke => true do
      @doc.css('div.evo-coverStories ul.cat-coverStories-subitems').count.should == @doc.css('div.cat-coverStories div.cvr-main').count
    end
    
    it "should have at least one subitem for each cover story", :smoke => true do
      @doc.css('div.evo-coverStories ul.cat-coverStories-subitems').each do |item|
        item.css('li').count.should > 0
      end
    end
    
    it "should have a link for every subitem for each cover story", :smoke => true do
      check_have_a_link_for_each('div.evo-coverStories ul.cat-coverStories-subitems li')
    end
    
    it "should have a text for every subitem for each cover story", :smoke => true do
      check_display_text_for_each('div.evo-coverStories ul.cat-coverStories-subitems li')
    end

  end
end