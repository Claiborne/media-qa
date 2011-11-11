require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/global_header_module"
require "files/helpers/ign_hubs_indices_module"

class TopUpcomingGames < Test::Unit::TestCase

  include GlobalHeaderMod
  include IGNHubsIndicesMod

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows",
      :url => "http://www.ign.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_top_upcoming_games
    
	sign_in
	
    # UPCOMING INDEX > RELEASE DATE > CHECK OBJECT PAGES FOR FIRST THREE ENTIRES
    # Open Upcoming Games
    @selenium.open "http://www.ign.com/index/upcoming.html"
	global_header("http://www.ign.com/index/upcoming.html")
    # Assert title contains "Top Upcoming Games"
    assert /^[\s\S]*Top Upcoming Games[\s\S]*$/ =~ @selenium.get_title
    # Sort by release date
    @selenium.click "link=Release Date"
    assert !6.times{ break if (@selenium.is_element_present("css=table#table-section-index tbody tr td[class='right col-width'] a[class*=asc]") rescue false); sleep 1 }
    # Click first game
    @selenium.click "css=tr:nth-child(2).game-row td:nth-child(2).up-com h3 a"
    @selenium.wait_for_page_to_load "40"
	global_header("first game entry in Top Upcoming Games index, sorted by release date")
    # =====================
    # =====================
    # CHECKS BASIC ELEMENTS OF GAME OBJECT-PAGES
    # Assert on object page: assert url contains ".com/objects"
    assert @selenium.is_element_present("css=meta[content*=.com/objects/]")
    # Assert on object page: assert <body> class contains "object"
    begin
        assert @selenium.is_element_present("css=body[class*=object]"), "First entry does not lead to object page - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Another way to assert on object page: check in script that IGN.pagetype = 'object';
    #    CHECKS BASIC ELEMENTS OF GAME OBJECT-HEADER
    # Verify object title string > 0
    title = @selenium.get_text("css=div#title-area h1.hdr-content a.game-title")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "First entry's page has no head title - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Release date string > 0
    title = @selenium.get_text("css=div#title-area div.txt-tagline")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "First entry's page has no release date string in object header - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # "More Info" <a> exists and text string > 0
    title = @selenium.get_text("css=a#more-info-lnk")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "First entry's page has 'More Info' <a> in object header - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END HEADER END
    # Assert "About" has > 0 string
    about_txt = @selenium.get_text("css=div#about-tabs-data")
    if about_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry's page has no 'About' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify "About" details contains > 0 string
    details_txt = @selenium.get_text("css=div#about-tabs-data div.column-about-details")
    if details_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry's page has no 'About Details' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify "About" details 2 contains > 0 string
    details2_txt = @selenium.get_text("css=div#about-tabs-data div.column-about-details-2")
    if details2_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry's page has no 'About Details 2' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify heading Top Discussions string > 0
    discuss_txt = @selenium.get_text("css=h3#top-discussions")
    if discuss_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First entry's page has no 'Top Discussions' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify Top Discussions <a> and contain href="http"
    begin
        assert @selenium.is_element_present("css=table#discussions a[href*=http]"), "First entry's page has no 'Top Discussions'<a> - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END OBJ PAGE END
    # =====================
    # =====================
    # Back to Upcoming
    @selenium.open "http://www.ign.com/index/upcoming.html"
    # Sort again
    @selenium.click "link=Release Date"
    assert !6.times{ break if (@selenium.is_element_present("css=table#table-section-index tbody tr td[class='right col-width'] a[class*=asc]") rescue false); sleep 1 }
    # Click second game
    @selenium.click "css=tr:nth-child(3).game-row td:nth-child(2).up-com h3 a"
    @selenium.wait_for_page_to_load "40"
    # =====================
    # =====================
    # CHECKS BASIC ELEMENTS OF GAME OBJECT-PAGES
    # Assert on object page: assert url contains ".com/objects"
    assert @selenium.is_element_present("css=meta[content*=.com/objects/]")
    # Assert on object page: assert <body> class contains "object"
    begin
        assert @selenium.is_element_present("css=body[class*=object]"), "Second entry does not lead to object page - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Another way to assert on object page: check in script that IGN.pagetype = 'object';
    #    CHECKS BASIC ELEMENTS OF GAME OBJECT-HEADER
    # Verify object title string > 0
    title = @selenium.get_text("css=div#title-area h1.hdr-content a.game-title")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "Second entry's page has no head title - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Release date string > 0
    title = @selenium.get_text("css=div#title-area div.txt-tagline")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "Second entry's page has no release date string in object header - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # "More Info" <a> exists and text string > 0
    title = @selenium.get_text("css=a#more-info-lnk")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "Second entry's page has no 'More Info' <a> in object header - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #    END HEADER END
    # Assert "About" has > 0 string
    about_txt = @selenium.get_text("css=div#about-tabs-data")
    if about_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry's page has no 'About' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify "About" details contains > 0 string
    details_txt = @selenium.get_text("css=div#about-tabs-data div.column-about-details")
    if details_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry's page has no 'About Details' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify "About" details 2 contains > 0 string
    details2_txt = @selenium.get_text("css=div#about-tabs-data div.column-about-details-2")
    if details2_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry's page has no 'About Details 2' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify heading Top Discussions string > 0
    discuss_txt = @selenium.get_text("css=h3#top-discussions")
    if discuss_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Second entry's page has no 'Top Discussions' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify Top Discussions <a> and contain href="http"
    begin
        assert @selenium.is_element_present("css=table#discussions a[href*=http]"), "Second entry's page has no 'Top Discussions' <a> - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END OBJ PAGE END
    # =====================
    # =====================
    # Back to Upcoming
    @selenium.open "http://www.ign.com/index/upcoming.html"
    # Sort again
    @selenium.click "link=Release Date"
    assert !6.times{ break if (@selenium.is_element_present("css=table#table-section-index tbody tr td[class='right col-width'] a[class*=asc]") rescue false); sleep 1 }
    # Click third game
    @selenium.click "css=tr:nth-child(4).game-row td:nth-child(2).up-com h3 a"
    @selenium.wait_for_page_to_load "40"
    # =====================
    # =====================
     # CHECKS BASIC ELEMENTS OF GAME OBJECT-PAGES
    # Assert on object page: assert url contains ".com/objects"
	begin
    assert @selenium.is_element_present("css=meta[content*=.com/objects/]"), "Third entry does not lead to object page - http://www.ign.com/index/upcoming.html sort release date"
	rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Assert on object page: assert <body> class contains "object"
    begin
        assert @selenium.is_element_present("css=body[class*=object]"), "Third entry does not lead to object page - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Another way to assert on object page: check in script that IGN.pagetype = 'object';
    #    CHECKS BASIC ELEMENTS OF GAME OBJECT-HEADER
    # Verify object title string > 0
    title = @selenium.get_text("css=div#title-area h1.hdr-content a.game-title")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "Third entry's page has no head title - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Release date string > 0
    title = @selenium.get_text("css=div#title-area div.txt-tagline")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "Third entry's page has no release date string in object header - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # "More Info" <a> exists and text string > 0
    title = @selenium.get_text("css=a#more-info-lnk")
    if title.length > 0 then bool = "true" 
	else bool = ""
	end
	title = ""
    begin
        assert_equal "true", bool, "Third entry's page has no 'More Info <a> in object header - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #    END HEADER END
    # Assert "About" has > 0 string
    about_txt = @selenium.get_text("css=div#about-tabs-data")
    if about_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry's page has no 'About' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify "About" details contains > 0 string
    details_txt = @selenium.get_text("css=div#about-tabs-data div.column-about-details")
    if details_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry's page has no 'About Details' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify "About" details 2 contains > 0 string
    details2_txt = @selenium.get_text("css=div#about-tabs-data div.column-about-details-2")
    if details2_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry's page has no 'About Details 2' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify heading Top Discussions string > 0
    discuss_txt = @selenium.get_text("css=h3#top-discussions")
    if discuss_txt.length > 0 then bool = "true" 
	else bool = ""
	end
    begin
        assert_equal "true", bool, "Third entry's page has no 'Top Discussions' entry - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # Verify Top Discussions <a> and contain href="http"
    begin
        assert @selenium.is_element_present("css=table#discussions a[href*=http]"), "Third entry's page has no 'Top Discussions' <a> - http://www.ign.com/index/upcoming.html sort release date"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END OBJ PAGE END
    # END END END
  end
end
