
module EventsMod

  def sign_in
	# SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
  end
  
  def event_banner(cur_page)
    # EVENT BANNER  
    # Event banner links to main event-page
    begin
        assert @selenium.is_element_present("css=div.shell a[href*=\"/events/e3\"]"), "Unable to verify the event banner on the #{cur_page} page displays and links back to the event hub" 
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	# Contains text "E3 2011"
	begin
        assert @selenium.get_text("css=div.shell a").match(/E3 2011/), "Unable to verify the event banner on the #{cur_page} page is showing the text 'E3 2011'"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
  end

  def blogroll_nav(cur_page)
    # BLOGROLL NAV
    # Each labeled correctly, "All" selected and rest have some js-href content
	begin
		assert_equal "All", @selenium.get_text("css=ul.ign-blogrollFilters li.firstFilter span"), "On the #{cur_page} page, unable to verify the first item in the blogroll nav is 'All'"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	blog_nav_item = ["Xbox 360", "PS3", "Wii", "PC", "DS", "PSP", "Mobile"]
	i = 2
	blog_nav_item.each do |item|
		begin
			assert_equal item, @selenium.get_text("css=ul.ign-blogrollFilters li:nth-child(#{i}) > a"), "On the #{cur_page} page, unable to verify the blogroll nav is working. (The #{i} numbered item did not match #{item})"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		i +=1
	end
  end

  def event_nav(cur_page)
    # EVENT NAV
    # Each <a> present and pointing to correct address
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/e3\"]"), "#{cur_page} page: Unable to verify 'Essentials' link in the event nav is visible and links to the main E3 page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=ul.contentNav a[href='/events/e3/2011/live-video']"), "#{cur_page} page: Unable to verify 'Essentials' link in the event nav is visible and links to the main E3 page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/e3/2011/news\"]"), "#{cur_page} page: Unable to verify 'News' link in the event nav is visible and links to the E3 news page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/e3/2011/games\"]"), "#{cur_page} page: Unable to verify 'Games' link in the event nav is visible and links to the E3 games page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/e3/2011/images\"]"), "#{cur_page} page: Unable to verify 'Images' link in the event nav is visible and links to the E3 images page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/e3/2011/videos\"]"), "#{cur_page} page: Unable to verify 'Videos' link in the event nav is visible and links to the E3 videos page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end

  def blogroll_iteration(cur_page)
	# BLOGROLL ENTRIES (IMG, TITLE, TEXT DISPLAY)
	for j in 1..8 do #Iterate through each blogroll nav item
		if @selenium.is_element_present("//div[@class='listElmnt-blogItem']")
			entries = @selenium.get_xpath_count("//div[@class='listElmnt-blogItem']").to_i
			indexof = @selenium.get_element_index("//div[@class='listElmnt-blogItem']").to_i + 1
			indexofpic = @selenium.get_element_index("//div[@class='listElmnt-blogItem']").to_i
		else 
			indexof = 0
			entries = 0
			indexofpic = 0
			puts "------------CAUTION-------------"
			puts "==> There are no blogroll entries in the "+j.to_s+" blogroll nav of the #{cur_page} page"
			puts""
		end
		if @selenium.is_element_present("css=ul.ign-blogrollFilters")
			current_tab = @selenium.get_text("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+")").to_s
		else
			begin
				assert @selenium.is_element_present("css=ul.ign-blogrollFilters"), "The blogroll nav is not visible when the blogroll is sorted by the "+j.to_s+" list item on the #{cur_page} page, and script could not continue interating through the nav"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			break
		end
		i = 1
		# Set up array to check for duplicates
		br_scrape = Array.new
		#puts entries 
		#puts indexof 
		#puts indexofpic
		while i <= entries.to_i 
			# For each blogroll entry: img src = http
			begin
				assert @selenium.is_element_present("//div[@id='ign-blogroll']/div["+indexofpic.to_s+"]/a[contains(@href,'http')]/img[contains(@src,'http')]"), "Unable to verify the "+i.to_s+" image is present in the blogroll in "+current_tab+" blogroll"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			indexofpic.to_i 
			indexofpic += 2	
			# For each blogroll entry: title text string > 0
			text = ""
			bool = ""
			text = @selenium.get_text("//div[@id='ign-blogroll']/div["+indexof.to_s+"]/h3")
			# Append array to check for duplicates
			br_scrape << text
			#puts "     "+text
			#puts "     -------------"
				if text.length > 0 then bool = "true" 
				else bool = ""
				end
			begin
				assert_equal "true", bool, "Unable to verify he "+i.to_s+" entry in the blogroll has a title on "+current_tab+" blogroll"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			# For each blogroll entry: blurb text string > 40
			text = ""
			bool = ""
			text = @selenium.get_text("//div[@id='ign-blogroll']/div["+indexof.to_s+"]/p")
			#puts "     "+text
			#puts ""
				if text.length > 40 then bool = "true" 
				else bool = ""
				end
			begin
				assert_equal "true", bool, "Unable to verify the "+i.to_s+" entry  in the blogroll has a blurb on "+current_tab+" blogroll"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			indexof.to_i
			indexof += 2
			i+= 1
		end
		
		# CHECK FOR DUPLICATES
		br_scrape_compare = br_scrape & br_scrape
		bl = br_scrape_compare == br_scrape
		begin
			assert bl, "There may be a duplicate entry in the "+current_tab+" blogroll"
		rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
		end
		
		# CHECK PAGINATION -- only works if first page of pagination is selected
		if @selenium.is_element_present("css=div.pagination")
			begin
				assert @selenium.is_element_present("css=div.pagination a:last-child[js-href*='/global/page/blogrollarticles.jsonp?page=2']"), "The 'next' pagination link might be broken on "+current_tab+" blogroll tab"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			i = 1
			num_page = @selenium.get_xpath_count("//div[@class='pagination']/a").to_i
			while i < num_page
				#puts i.to_s+" pagination"
				i+= 1
				begin
					assert @selenium.is_element_present("css=div.pagination a[js-href*='/global/page/blogrollarticles.jsonp?page=']"), "The "+i.to_s+" pagination link might be broken on "+current_tab+" blogroll tab"
				rescue Test::Unit::AssertionFailedError
					@verification_errors << $!
				end
			end
		else
			if entries > 23
				puts "------------CAUTION-------------"
				puts "==> The "+current_tab+" tab on the #{cur_page} page has 24 entries but no pagination"
				puts""
			end
		end
		j+=1
		if j < 9
			#puts @selenium.get_text("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+") > a")
			@selenium.click("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+") > a")
			sleep 3
		end
	end
  end
  
  def games_blogroll_nav
	nav_list = ["All", "Xbox 360", "PS3", "Wii", "PC", "3DS", "PS NGP", "iPhone", "iPad", "Android"]
	i = 1
	nav_list.each do |item|
		begin
			assert_equal item, @selenium.get_text("css=ul.ign-blogrollFilters li:nth-child(#{i})"), "Unable to verify all the appropriate platforms are listed in the  blogroll nav of the games page. '#{item}' was not in the #{i} numbered entry in the nav"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	i +=1
	end
  end
end