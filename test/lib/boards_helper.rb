module BoardsHelper

  def check_sidebar_log_in

    it "should display", :spam => true do
      @selenium.find_elements(:css => "div.sidebar a[class='inner authReturnUrl']").count.should == 1
      @selenium.find_element(:css => "div.sidebar a[class='inner authReturnUrl']").displayed?.should be_true
    end

    it 'should link to the sign-in page with a proper redirect back' do
      @selenium.find_element(:css => "div.sidebar a[class='inner authReturnUrl']").attribute('href').to_s.match(/s.ign.com\/login?r=#{@selenium.current_url}/)
    end
  end

  def check_main_section_list
    it 'should correctly display each category' do
      list = return_boards_list
      categories =  @selenium.find_elements(:css => "ol#forums div.categoryText")
      categories.count.should == list.length
      n = 0
      categories.each do |cat|
        cat.text.downcase.should == list[n].keys[0].to_s
        n = n+1
      end
    end

    it 'should correctly display each sub-category' do
      list = return_boards_list
      n = 0
      @selenium.find_elements(:css => "ol#forums li.category ol.nodeList").length.should > 1
      @selenium.find_elements(:css => "ol#forums li.category ol.nodeList").each do |cat|
        x = 0
        cat.find_elements(:css => 'h3.nodeTitle').length.should > 1
        cat.find_elements(:css => 'h3.nodeTitle').each do |sub|
          sub.text.downcase.should == list[n][list[n].keys[0]][x].to_s
          x = x+1
        end
        n = n+1
      end
    end
  end

  def check_main_section_links

    it 'should not contain broken links to threads', :spam => true do
      errors = []
      err_msg = []
      @selenium.find_elements(:css => "ol#forums div.categoryText a").each do |a|
        begin
          rest_client_not_301_open a.attribute('href').to_s
        rescue Exception => e
          errors << e
          err_msg << e.message
        end
      end
      raise errors[0], err_msg.to_s if errors[0]

      errors = []
      err_msg = []
      @selenium.find_elements(:css => "ol#forums li.category ol.nodeList h3 a").each do |a|
        begin
          puts a.text
          rest_client_not_301_open a.attribute('href').to_s
          raise Exception.new "nonono"
        rescue Exception => e
          errors << e
          err_msg << e.message
        end
      end
      raise errors[0], err_msg.to_s if errors[0]
    end
  end

  def return_boards_list
    [
      {
      :'community central' => [
        :'the vestibule',
        :'the gcb',
        ]
      },
      {
      :'the vault' => [
        :acfriends,
        :darktide,
        :outpost
        ]
      },
      {
        :'gaming' => [
          :xbox,
          :nintendo,
          :pc,
          :playstation,
          :'ios gaming',
          :gamespy,
          :'all game boards'
        ]
      },
      {
        :'entertainment' => [
          :movies,
          :television,
          :comics,
          :anime,
          :music
        ]
      },
      {
        :'sports' => [
          :'sports community board',
          :baseball,
          :soccer,
          :'college basketball',
          :basketball,
          :football,
          :'college football',
          :hockey,
          :'pro wrestling',
          :'other sports'
        ]
      },
      {
        :'technology' => [
          :'apple board',
          :'android board',
          :'tech board',
          :'cars lobby'
        ]
      },
      {
        :'other community boards' => [
          :'current events',
          :international,
          :'sex, health and dating',
          :'my ign',
          :'feature and board requests',
          :'wikis discussion',
          :'issues & bug reports',
          :'announcements'
        ]
      },
      {
        :'ign prime vip board' => [
          :gaming,
          :'movies, tv, and tech'
        ]
      }
    ]
  end

end
