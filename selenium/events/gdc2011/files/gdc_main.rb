require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class GDCMain < Test::Unit::TestCase
  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows",
      :url => "http://www.ign.com/events/",
      :timeout_in_second => 60
	  
    @selenium.start_new_browser_session	
	puts ":::::::::GDC MAIN/ESSENTAILS PAGE:::::::::"
  end
  
  def teardown
	puts ":::::::::END MAIN/ESSENTIALS:::::::::"
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_events
  
	# SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "30000"
	
	# OPEN PAGE
    @selenium.open "/gdc"
	
	# VERIFY TITLE
    begin
        assert /^[\s\S]*GDC[\s\S]*$/ =~ @selenium.get_title, "Event main-page title does not match."
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# EVENT BANNER  
    # Event banner links to main event-page
    begin
        assert @selenium.is_element_present("css=div.shell a[href*=\"/events/gdc\"]"), "Event banner div moved or does not link to correct page" 
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	# Event banner img src = http
	begin
        assert @selenium.is_element_present("css=div.shell a img[src*=\"http\"]"), "Event bnanner img src != http"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# EVENT NAV
    # Each <a> present and pointing to correct address
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/gdc\"]"), "A nav item not pointing to /events/gdc"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/gdc/2011/news\"]"), "Essentials nav item not pointing to events/gdc/2011/news"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/gdc/2011/games\"]"), "News nav item not pointing to events/gdc/2011/games"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/gdc/2011/images\"]"), "Games nav item not pointing to events/gdc/2011/images"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul.contentNav a[href=\"/events/gdc/2011/videos\"]"), "Images nav item not pointing to events/gdc/2011/vidoes"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
    # Each <a> correctly labeled
    begin
        assert /^[\s\S]*Essentials[\s\S]*$/ =~ @selenium.get_text("css=ul.contentNav li:nth-child(1)"), "Essentials nav item text doesn't inclide Essentials"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*News[\s\S]*$/ =~ @selenium.get_text("css=ul.contentNav li:nth-child(2)"), "News nav item text doesn't inclide News"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Games[\s\S]*$/ =~ @selenium.get_text("css=ul.contentNav li:nth-child(3)"), "Games nav item text doesn't inclide Games"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Images[\s\S]*$/ =~ @selenium.get_text("css=ul.contentNav li:nth-child(4)"), "Images nav item text doesn't inclide Images"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert /^[\s\S]*Videos[\s\S]*$/ =~ @selenium.get_text("css=ul.contentNav li:nth-child(5)"), "Video nav item text doesn't inclide Vidoes"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# HERO BOX MAIN (left portion)
    # For each five displays: a href & img src = http
	for i1 in 0..4 do
		begin
			assert @selenium.is_element_present("css=div[class='grid_24 alpha omega cvr-display_"+i1.to_s+"'] div.cvr-main a[href*='http'] img[src*='http']") || @selenium.is_element_present("css=div[class='grid_24 alpha omega cvr-display_"+i1.to_s+"'] div.cvr-main a[onclick*='IGN.HeroUnit'] img[src*='http']"), "The "+i1.to_s+" hero box a href or img src != http"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end

	# HERO BOX HIGHLIGHTS (right portion)
    # For each check title contains string; sting > 0
	for i2 in 0..4 do
		# For each verify element present:
		begin
			assert @selenium.is_element_present("css=div[class='grid_24 alpha omega cvr-display_"+i2.to_s+"'] div.cvr-highlights div.cvr-highlightsTitle"), "The "+i2.to_s+" hero box right potion div has moved"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		# For each get string
		text =""
		bool =""
		text = @selenium.get_text("css=div[class='grid_24 alpha omega cvr-display_"+i2.to_s+"'] div.cvr-highlights div.cvr-highlightsTitle")
		if text.length > 0 then bool = "true" 
		else bool = ""
		end
		# For each assert string > 0
		begin
			assert_equal "true", bool, "The "+i2.to_s+" hero box right potion has no title text "
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	
	# HERO THUMBS
    # a href & img src = http
	for i3 in 1..5 do
		begin
			assert @selenium.is_element_present("//ul[@class='cvr-thumbs']/li["+i3.to_s+"]/a[contains(@href,'http')]/img[contains(@src,'http')]") || @selenium.is_element_present("//ul[@class='cvr-thumbs']/li["+i3.to_s+"]/a[contains(@onclick,'IGN.HeroUnit')]/img[contains(@src,'http')]"), "The "+i3.to_s+" hero thumb a href or img src != http"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	
	# BLOGROLL TITLE
	# Blogroll title contains "Top Stories"
	begin
		assert /^[\s\S]*Top Stories[\s\S]*$/ =~ @selenium.get_text("css=h1[class=\"contentHeader typekit\"]"), "Essentials page does not have 'Top Stories' it blogroll title"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	# BLOGROLL NAV
    # Each labeled correctly, "All" selected and rest have some js-href content
	begin
        assert_equal "All", @selenium.get_text("css=ul.ign-blogrollFilters li span"), "First blogroll nav not All or not a"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert_equal "Xbox 360", @selenium.get_text("//ul[@class='ign-blogrollFilters']/li[2]/a[contains(@js-href,'/global/page/blogrollarticles.jsonp?page=')]"), "Second blogroll nav not Xbox 360 or not a"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert_equal "PS3", @selenium.get_text("//ul[@class='ign-blogrollFilters']/li[3]/a[contains(@js-href,'/global/page/blogrollarticles.jsonp?page=')]"), "Third blogroll nav not PS3 or not a"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert_equal "Wii", @selenium.get_text("//ul[@class='ign-blogrollFilters']/li[4]/a[contains(@js-href,'/global/page/blogrollarticles.jsonp?page=')]"), "Fourth blogroll nav not Wii or not a"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert_equal "PC", @selenium.get_text("//ul[@class='ign-blogrollFilters']/li[5]/a[contains(@js-href,'/global/page/blogrollarticles.jsonp?page=')]"), "Fifth blogroll nav not PC or not a"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert_equal "DS", @selenium.get_text("//ul[@class='ign-blogrollFilters']/li[6]/a[contains(@js-href,'/global/page/blogrollarticles.jsonp?page=')]"), "Sixth blogroll nav not DS or not a"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert_equal "PSP", @selenium.get_text("//ul[@class='ign-blogrollFilters']/li[7]/a[contains(@js-href,'/global/page/blogrollarticles.jsonp?page=')]"), "Seventh blogroll nav not PSP or not a"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert_equal "Mobile", @selenium.get_text("//ul[@class='ign-blogrollFilters']/li[8]/a[contains(@js-href,'/global/page/blogrollarticles.jsonp?page=')]"), "Eighth blogroll nav not Mobile or not a"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# BLOGROLL ENTRIES (IMG, TITLE, TEXT DISPLAY)
	for j in 1..8 do  #Iterate through each blogroll nav item
		if @selenium.is_element_present("//div[@class='listElmnt-blogItem']")
			entries = @selenium.get_xpath_count("//div[@class='listElmnt-blogItem']").to_i
			indexof = @selenium.get_element_index("//div[@class='listElmnt-blogItem']").to_i + 1
			indexofpic = @selenium.get_element_index("//div[@class='listElmnt-blogItem']").to_i
		else 
			indexof = 0
			entries = 0
			indexofpic = 0
			puts "-----------------------"
			puts "There are no blogroll entries in the "+j.to_s+" blogroll nav of the main/essentials page"
			puts "-----------------------"
		end
		if @selenium.is_element_present("css=ul.ign-blogrollFilters")
			current_tab = @selenium.get_text("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+")").to_s
		else
			begin
				assert @selenium.is_element_present("css=ul.ign-blogrollFilters"), "The blogroll nav is not visible when the blogroll is sorted by the "+j.to_s+" list item on the Essentials page, and script could not continue"
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
				assert @selenium.is_element_present("//div[@id='ign-blogroll']/div["+indexofpic.to_s+"]/a[contains(@href,'http')]/img[contains(@src,'http')]"), "The "+i.to_s+" image is not present in the blogroll on "+current_tab+" blogroll"
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
				assert_equal "true", bool, "The "+i.to_s+" entry in the blogroll may have no title on "+current_tab+" blogroll"
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
				assert_equal "true", bool, "The "+i.to_s+" entry  in the blogroll may have no blurb on "+current_tab+" blogroll"
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
			assert bl, "There is a duplicate entry in the "+current_tab+" blogroll"
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
			if entries > 9
				puts "--------------------------"
				puts "--------------------------"
				puts "==> The "+current_tab+" tab on the Essentials page has 10 entries but no pagination"
				puts "--------------------------"
				puts "--------------------------"
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
end



	