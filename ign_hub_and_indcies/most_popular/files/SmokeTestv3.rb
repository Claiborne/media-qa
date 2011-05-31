require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"

class SmokeTestv3 < Test::Unit::TestCase

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
    # SIGN IN
    @selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "smoketest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "30000"
    # END SIGN IN
    # CHECK 360 AND PS3 HUB W/ CONTENT. CHECK 360 AND PS3 INDICIES, FIRST THRE FROM PULL D0WN MENU, NO CONTENT
    # OPEN www.ign.com 
    @selenium.open "/"
    # HEADER
    # Nav Links
    begin
        assert @selenium.is_element_present("css=a.nav-lnk[title=Home][href=http://www.ign.com]"), "Global header 'Home' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-myign a[href=http://my.ign.com]"), "Global header 'MyIGN' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-xbox-360 a[href=http://xbox360.ign.com]"), "Global header 'Xbox' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-ps3 a[href=http://ps3.ign.com]"), "Global header 'PS3' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-wii a[href=http://wii.ign.com]"), "Global header 'Wii' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-pc a[href=http://pc.ign.com]"), "Global header 'PC' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-ds a[href=http://ds.ign.com]"), "Global header 'DS' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-psp a[href=http://psp.ign.com]"), "Global header 'PSP' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-wireless a[href=http://wireless.ign.com]"), "Global header 'iPhone' nav link"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # END HEADER
    # 360 HUB
    # xbox360 link
    @selenium.click "css=a.xbox-360"
    @selenium.wait_for_page_to_load "30000"
    # assert title
    assert /^[\s\S]*Microsoft Xbox 360[\s\S]*Games[\s\S]*$/ =~ @selenium.get_title
    # hero box featured img + a
    begin
        assert @selenium.is_element_present("css=div#hu0l a[href*=http] img[src*=http]") || @selenium.is_element_present("css=div#hu0l a[onclick*='IGN.HeroUnit'] img[src*=http]"), "Hero box featured (huo1) may not contain <a> or <img> -- main Xbox hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # hero box thumb img + a
    begin
        assert @selenium.is_element_present("css=ol.thumbs li a[href*=http] img[src*=http]"), "First Hero box thumb may not contain <a> or <img> -- main Xbox hub"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    # blogroll "Top Stories" present + selected
    begin
    assert_equal "Top Stories", @selenium.get_text("css=ul#left-col-consoles li a"), "Top Stories bloroll nav is not selected or not present -- main Xbox hub"
    rescue Test::Unit::AssertionFailedError
    @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=ul#left-col-consoles li a[class=\"filter-js filter selected\"]"), "Top Stories bloroll nav is not selected or not present -- main Xbox hub"
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
    # END 360 HUB
    # OPEN www.ign.com 
    @selenium.open "/"
    # PS3 HUB
    # ps3 link
    @selenium.click "css=a.ps3"
    @selenium.wait_for_page_to_load "30000"
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
    # END PS3 HUB
    # OPEN www.ign.com 
    @selenium.open "/"
    # 360 INDICES
    # "Reviews & Top Games" index
    @selenium.open "http://xbox360.ign.com/index/top-reviewed.html"
    assert_equal "Xbox 360 Reviews, The Best Xbox 360 Games - Top Reviewed Xbox 360 Games at IGN", @selenium.get_title, "http://xbox360.ign.com/index/top-reviewed.html did not load or title has changed"
    # "Top Stories" index
    @selenium.open "http://xbox360.ign.com/index/features.html"
    assert_equal "Xbox 360 Reviews, Previews, Game Trailers & Videos - Xbox 360 News & Updates at IGN", @selenium.get_title, "http://xbox360.ign.com/index/features.html did not load or title has changed"
    # "Video" index
    @selenium.open "http://xbox360.ign.com/index/videos.html"
    assert_equal "IGN Xbox 360: Games, Cheats, News, Reviews, and Previews", @selenium.get_title, "http://xbox360.ign.com/index/videos.html did not load or title has changed"
    # END 360 INDICES
    # PS3 INDICES
    # "Reviews & Top Games" index
    @selenium.open "http://ps3.ign.com/index/top-reviewed.html"
    assert_equal "PlayStation 3 Reviews, The Best PS3 Games - Top Reviewed PS3 Games at IGN", @selenium.get_title, "http://ps3.ign.com/index/top-reviewed.html did not load or title has changed"
    # "Top Stories" index
    @selenium.open "http://ps3.ign.com/index/features.html"
    assert_equal "Playstation 3 Reviews, Previews, Game Trailers & Videos - PS3 News & Updates at IGN", @selenium.get_title, "http://ps3.ign.com/index/features.html did not load or title has changed"
    # "Video" index
    @selenium.open "http://ps3.ign.com/index/videos.html"
    assert_equal "IGN PS3: Games, Cheats, News, Reviews, and Previews", @selenium.get_title, "http://ps3.ign.com/index/videos.html did not load or title has changed"
    # END PS3 INDICES
    # END END END
  end
end
