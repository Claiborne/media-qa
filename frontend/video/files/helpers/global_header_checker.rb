
module GlobalHeaderChecker

  def check_global_header(descript)
  
	# NAV LINKS
    begin
        assert @selenium.is_element_present("css=a.nav-lnk[title=Home][href=http://www.ign.com]"), "Unable to verify Global header 'Home' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-myign a[href=http://my.ign.com]"), "Unable to verify Global header 'MyIGN' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-xbox-360 a[href=http://xbox360.ign.com]"), "Unable to verify Global header 'Xbox' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-ps3 a[href=http://ps3.ign.com]"), "Unable to verify Global header 'PS3' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-wii a[href=http://wii.ign.com]"), "Unable to verify Global header 'Wii' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-pc a[href=http://pc.ign.com]"), "Unable to verify Global header 'PC' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-ds a[href=http://ds.ign.com]"), "Unable to verify Global header 'DS' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-psp a[href=http://psp.ign.com]"), "Unable to verify Global header 'PSP' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("css=li#navItem-wireless a[href=http://wireless.ign.com]"), "Unable to verify Global header 'iPhone' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=li#navItem-reviews a[href=http://www.ign.com/index/reviews.html]"), "Unable to verify Global header 'Reviews' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=li#navItem-upcoming a[href=http://www.ign.com/index/upcoming.html]"), "Unable to verify Global header 'Upcoming' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=li#navItem-news a[href=http://www.ign.com/index/features.html]"), "Unable to verify Global header 'News' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=li#navItem-video a[href=http://www.ign.com/videos]"), "Unable to verify Global header 'Video' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	  begin
        assert @selenium.is_element_present("css=li#navItem-guides a[href=http://guides.ign.com]"), "Unable to verify Global header 'Guides' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=li#navItem-cheats a[href=http://www.ign.com/cheats]"), "Unable to verify Global header 'Cheats' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=li#navItem-movies a[href=http://movies.ign.com]"), "Unable to verify Global header 'Movies' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=li#navItem-tv a[href=http://tv.ign.com]"), "Unable to verify Global header 'TV' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=li#navItem-more a"), "Unable to verify Global header 'More' nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    
	# CORP LINKS
	begin
        assert @selenium.is_element_present("css=div#corp-networkLinks a[href=http://www.ign.com/]"), "Unable to verify Global header 'IGN' corp nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=div#corp-networkLinks a[href=http://www.ign.com/]"), "Unable to verify Global header 'GameSpy' corp nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=div#corp-networkLinks a[href=http://www.fileplanet.com/]"), "Unable to verify Global header 'FilePlanet' corp nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=div#corp-networkLinks a[href=http://www.teamxbox.com/]"), "Unable to verify Global header 'TeamXbox' corp nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=div#corp-networkLinks a[href=http://www.gamestats.com/]"), "Unable to verify Global header 'GameStats' corp nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=div#corp-networkLinks a[href*=http://www.direct2drive.com]"), "Unable to verify Global header 'FilePlanet' corp nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	begin
        assert @selenium.is_element_present("css=div#corp-networkLinks a[href=http://www.ign.com/ipl]"), "Unable to verify Global header 'IPL' corp nav link working on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	begin
        assert /IGN Entertainment Games/ =~ @selenium.get_text("css=div#corp-networkLinks"), "Unable to verify 'IGN Entertainment Games' text present in Global header corp links on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	# GLOBAL SEARCH
	begin
        assert @selenium.is_element_present("css=input#search-global"), "Unable to verify Global search is displaying on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	# GLOBAL LOGO
	begin
        assert @selenium.is_element_present("css=div#logo-ign"), "Unable to verify Global search is displaying on #{descript}"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
  end
end