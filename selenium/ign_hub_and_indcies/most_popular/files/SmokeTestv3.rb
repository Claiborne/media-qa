require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/global_header_module"
require "files/helpers/ign_hubs_indices_module"

class SmokeTestv3 < Test::Unit::TestCase

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
  
  def test_smoke_testv3
    
	sign_in
	@selenium.open "/"
	global_header("main page")
    
    # 360 HUB
	
    # xbox360 link
    @selenium.click "css=a.xbox-360"
    @selenium.wait_for_page_to_load "40"
	global_header("360 Hub")
	
    # assert title
	begin
    assert /^[\s\S]*Microsoft Xbox 360[\s\S]*Games[\s\S]*$/ =~ @selenium.get_title, "On the main page, when the Xbox 360 hub link in the global nav is clicked, unable to verify the page title matches Xbox 360 hub"
	rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
    # hero box featured contains img + a
    check_hero_box("360 Hub")
	
    # hero box thumb img + a
    check_hero_thumb("360 Hub")
	
    # blogroll "Top Stories" selected
    begin
        assert @selenium.is_element_present("css=ul#left-col-consoles li a[class=\"filter-js filter selected\"]"), "360 Hub - Unable to verify 'Top Stories' is displayed in the blogroll nav and is the default blogroll sort"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
    # At least one blogroll article (img, title, para)
    begin
        assert @selenium.is_element_present("css=div.img-thumb a img[src*=http]"), "First blogroll image may not contain an <a> or <img> -- main Xbox hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #    Text in title?
    title = @selenium.get_text("css=div.txt-para h3 a")
    if title.length > 0 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First blogroll article may not contain title -- main Xbox hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #    Text in paragraph?
    para = @selenium.get_text("css=div.txt-para div.content-headlines")
    if para.length > 21 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First blogroll article may not contain a blurb under the title -- main Xbox hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end

    # PS3 HUB
	
    # ps3 link
	@selenium.open "/"
    @selenium.click "css=a.ps3"
    @selenium.wait_for_page_to_load "40"
	global_header("PS3 Hub")
    # Verify title
    begin
        assert /^[\s\S]*Sony PlayStation 3[\s\S]*PS3[\s\S]*$/ =~ @selenium.get_title, "PS3 Hub title error --  may not be on PS3 hub or title has changed"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # hero box featured img + a
    begin
        assert @selenium.is_element_present("css=div#hu0l a[href*=http] img[src*=http]"), "Hero box featured (huo1) may not contain <a> or <img> -- main PS3 hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # hero box thumb img + a
    begin
        assert @selenium.is_element_present("css=ol.thumbs li a[href*=http] img[src*=http]"), "First Hero box thumb may not contain <a> or <img> -- main PS3 hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # blogroll "Top Stories" present, selected
    begin
    assert_equal "Top Stories", @selenium.get_text("css=ul#left-col-consoles li a"), "Top Stories not selected or not present on PS3 main hub"
    rescue Test::Unit::AssertionFailedError
    @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul#left-col-consoles li a[class=\"filter-js filter selected\"]"), "Top Stories not selected or not present on PS3 main hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # At least one blogroll article (img, title, para)
    begin
        assert @selenium.is_element_present("css=div.img-thumb a img[src*=http]"), "First blogroll image may not contain an <a> or <img> -- main PS3 hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #    Text in title?
    title = @selenium.get_text("css=div.txt-para h3 a")
    if title.length > 0 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First blogroll article may not contain a title -- main PS3 hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    #    Text in paragraph?
    para = @selenium.get_text("css=div.txt-para div.content-headlines")
    if para.length > 21 then bool = "true"
	else bool = ""
	end
    begin
        assert_equal "true", bool, "First blogroll article may not contain a blurb below the title -- main PS3 hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end

    # 360 INDICES
	
    # "Reviews & Top Games" index
    @selenium.open "http://xbox360.ign.com/index/top-reviewed.html"
	global_header("http://xbox360.ign.com/index/top-reviewed.html")
	begin
		assert_equal "Xbox 360 Reviews, The Best Xbox 360 Games - Top Reviewed Xbox 360 Games at IGN", @selenium.get_title, "http://xbox360.ign.com/index/top-reviewed.html did not load or title has changed"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
    # "Top Stories" index
    @selenium.open "http://xbox360.ign.com/index/features.html"
	global_header("http://xbox360.ign.com/index/features.html")
	begin
		assert_equal "Xbox 360 Reviews, Previews, Game Trailers & Videos - Xbox 360 News & Updates at IGN", @selenium.get_title, "http://xbox360.ign.com/index/features.html did not load or title has changed"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
    # "Video" index
    @selenium.open "http://xbox360.ign.com/index/videos.html"
	global_header("http://xbox360.ign.com/index/videos.html")
	begin
		assert_equal "IGN Xbox 360: Games, Cheats, News, Reviews, and Previews", @selenium.get_title, "http://xbox360.ign.com/index/videos.html did not load or title has changed"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
	
    # PS3 INDICES
	
    # "Reviews & Top Games" index
    @selenium.open "http://ps3.ign.com/index/top-reviewed.html"
	global_header("http://ps3.ign.com/index/top-reviewed.html")
    assert_equal "PlayStation 3 Reviews, The Best PS3 Games - Top Reviewed PS3 Games at IGN", @selenium.get_title, "http://ps3.ign.com/index/top-reviewed.html did not load or title has changed"
    # "Top Stories" index
    @selenium.open "http://ps3.ign.com/index/features.html"
	global_header("http://ps3.ign.com/index/features.html")
	begin
		assert_equal "Playstation 3 Reviews, Previews, Game Trailers & Videos - PS3 News & Updates at IGN", @selenium.get_title, "http://ps3.ign.com/index/features.html did not load or title has changed"
	rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # "Video" index
    @selenium.open "http://ps3.ign.com/index/videos.html"
	global_header("http://ps3.ign.com/index/videos.html")
	begin
		assert_equal "IGN PS3: Games, Cheats, News, Reviews, and Previews", @selenium.get_title, "http://ps3.ign.com/index/videos.html did not load or title has changed"
	rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end
end
