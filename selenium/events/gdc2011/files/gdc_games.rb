require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class GDCGames < Test::Unit::TestCase
  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows",
      :url => "http://www.ign.com/events/",
      :timeout_in_second => 60
	  
    @selenium.start_new_browser_session
	puts ":::::::::GDC GAMES PAGE:::::::::"
  end
  
  def teardown
	puts ":::::::::END GAMES:::::::::"
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
    @selenium.open "http://www.ign.com/events/gdc/2011/games"
	
	# BLOGROLL TITLE
	# Blogroll title contains "Games"
	begin
		assert /^[\s\S]*Games[\s\S]*$/ =~ @selenium.get_text("css=h1[class=\"contentHeader typekit\"]"), "Games blogroll tab -- blogroll title is wrong"
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
	
	# BLOGROLL NAV
    # Is present
	begin
        assert @selenium.is_element_present("css=div.ign-blogrollFiltersContainer ul:nth-child(1).ign-blogrollFilters > li"), "The blogroll nav is missing"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# BLOGROLL ENTRIES (TITLE, TEXT DISPLAY)
	for j in 1..14 do  #Iterate through each blogroll nav item
		if @selenium.is_element_present("//div[@class='gameListItem']") 
			entries = @selenium.get_xpath_count("//div[@class='gameListItem']").to_i
			indexof = @selenium.get_element_index("//div[@class='gameListItem']").to_i + 1 
		else 
			indexof = 0
			entries = 0
			puts "-----------------------"
			puts "There are no blogroll entries in the "+j.to_s+" blogroll nav of the games page"
			puts "-----------------------"
		end
		if @selenium.is_element_present("css=ul.ign-blogrollFilters")
			current_tab = @selenium.get_text("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+")").to_s
		else
			begin
				assert @selenium.is_element_present("css=ul.ign-blogrollFilters"), "The blogroll nav is not visible when the blogroll is sorted by the "+j.to_s+" list item on the Games page, and script could not continue"
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
		while i <= entries.to_i do
			# For each blogtoll entry: title text string > 0
			text = ""
			bool = ""
			text = @selenium.get_text("//div[@id='ign-blogroll']/div["+indexof.to_s+"]/h3/a[contains(@href,'http')]")
			#puts "     "+text
			#puts "     -------------"
				if text.length > 0 then bool = "true" 
				else bool = ""
				end
			begin
				assert_equal "true", bool, "The "+i.to_s+" entry in the blogroll may have no title on "+current_tab+" blogroll tab or may not be linked"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			# For each blogtoll entry: blurb text string > 30
			text = ""
			bool = ""
			text = @selenium.get_text("//div[@id='ign-blogroll']/div["+indexof.to_s+"]/p")
			#puts "     "+text
			#puts ""
				if text.length > 30 then bool = "true" 
				else bool = ""
				end
			begin
				assert_equal "true", bool, "The "+i.to_s+" entry  in the blogroll may have no blurb on "+current_tab+" blogroll tab"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			indexof.to_i
			indexof += 1
			i+= 1
		end
		
		# CHECK PAGINATION -- only works if first page of pagination is selected
		if @selenium.is_element_present("css=div.pagination")
			begin
				assert @selenium.is_element_present("css=div.pagination a:last-child[js-href*='/global/page/blogrollgames.jsonp?page=2']"), "The 'next' pagination link might be broken on "+current_tab+" blogroll tab"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			i = 1
			num_page = @selenium.get_xpath_count("//div[@class='pagination']/a").to_i
			while i < num_page
				#puts i.to_s+" pagination"
				i+= 1
				begin
					assert @selenium.is_element_present("css=div.pagination a[js-href*='/global/page/blogrollgames.jsonp?page=']"), "The "+i.to_s+" pagination link might be broken on "+current_tab+" blogroll tab"
				rescue Test::Unit::AssertionFailedError
					@verification_errors << $!
				end
			end
		else
			if entries > 9
				puts "--------------------------"
				puts "--------------------------"
				puts "==> The "+current_tab+" tab on the Games page has 10 entries but no pagination"
				puts "--------------------------"
				puts "--------------------------"
			end
		end
		j+=1
		if j < 15
			#puts @selenium.get_text("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+") > a")
			@selenium.click("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+") > a")
			sleep 3
		end
	end	
  end
end