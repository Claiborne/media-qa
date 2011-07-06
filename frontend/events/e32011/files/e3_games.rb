require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require 'files/helpers/events_mod'
require 'files/helpers/global_header_module'

class E3Games < Test::Unit::TestCase

  include EventsMod
  include GlobalHeaderMod
  
  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows",
      :url => "http://www.ign.com/events/",
      :timeout_in_second => 60
	  
    @selenium.start_new_browser_session
	puts ":::::::::::::E3 GAMES PAGE:::::::::::::"
	puts""
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_games
  
	sign_in
	
	# OPEN PAGE
    @selenium.open "http://www.ign.com/events/e3/2011/games"
	
	global_header("Games")
	
	# BLOGROLL TITLE
	# Blogroll title contains "Games"
	begin
		assert /^[\s\S]*Games[\s\S]*$/ =~ @selenium.get_text("css=h1[class=\"contentHeader typekit\"]"), "Unable to verify the Games page blogroll title is visible"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	event_banner("Games")
	
	event_nav("Games")
	
	games_blogroll_nav
	
	# BLOGROLL ENTRIES (TITLE, TEXT DISPLAY)
	for j in 1..10 do  #Iterate through each blogroll nav item
		if @selenium.is_element_present("//div[@class='gameListItem']") 
			entries = @selenium.get_xpath_count("//div[@class='gameListItem']").to_i
			indexof = @selenium.get_element_index("//div[@class='gameListItem']").to_i + 1 
		else 
			indexof = 0
			entries = 0
			puts "------------CAUTION-------------"
			puts "==> There are no blogroll entries in the "+j.to_s+" blogroll nav of the games page"
			puts""
		end
		if @selenium.is_element_present("css=ul.ign-blogrollFilters")
			current_tab = @selenium.get_text("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+")").to_s
		else
			begin
				assert @selenium.is_element_present("css=ul.ign-blogrollFilters"), "The blogroll nav is not visible when the blogroll is sorted by the "+j.to_s+" list item on the Games page, and script could not continue interating through the nav"
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
				assert_equal "true", bool, "he "+i.to_s+" entry in the blogroll may have no title on "+current_tab+" blogroll tab or may not be linked"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			# For each blogtoll entry: blurb text string > 30
			#text = ""
			#bool = ""
			#text = @selenium.get_text("//div[@id='ign-blogroll']/div["+indexof.to_s+"]/p")
			#puts "     "+text
			#puts ""
				#if text.length > 30 then bool = "true" 
				#else bool = ""
				#end
			#begin
				#assert_equal "true", bool, "The "+i.to_s+" entry  in the blogroll may have no blurb on "+current_tab+" blogroll tab"
			#rescue Test::Unit::AssertionFailedError
				#@verification_errors << $!
			#end
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
			if entries > 23
				puts "------------CAUTION-------------"
				puts "==> The "+current_tab+" tab on the Games page has 24 entries but no pagination"
				puts""
			end
		end
		j+=1
		if j < 11
			@selenium.click("css=ul.ign-blogrollFilters li:nth-child("+j.to_s+") > a")
			sleep 3
		end
	end	
  end
end