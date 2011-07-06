
module SocialMyIGNPagesProfileMod

  def check_myprofile_page
  
    #Define blogroll nav links
	#profile_br_nav = ["http://people.ign.com/clay.ign","http://www.ign.com/blogs/clay.ign","http://people.ign.com/clay.ign/games","http://people.ign.com/clay.ign/people"]
	profile_br_nav = ["http://stg-people.ign.com/clay.ign","http://www.ign.com/blogs/clay.ign","http://stg-people.ign.com/clay.ign/games","http://stg-people.ign.com/clay.ign/people"]
  
	#Check name visible in header
    text = @selenium.get_text("css=div.profileInfo div.username")
    if text.length > 2 then bool = "true" 
		else bool = ""
	end
    begin
        assert_equal "true", bool, "Unable to verify user name is visible in the content header of the MyIGN 'My Profile' page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	#Check avatar visible in header
	begin
        assert @selenium.is_element_present("css=div.avatarFrame img[src*='http']"), "Unable to verify the user's avatar pic is visible in the content header of the MyIGN 'My Profile' page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	#Check blognav: all href = correct http address
	profile_br_nav.each do |i|
		begin
			assert @selenium.is_element_present("css=ul.socialPeopleBar a[href='#{i}']"), "Unable to verify the content nav links on MyIGN's 'My Profile' page work or point to the correct pages'"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	
	#Check some text appear in main content
    text = @selenium.get_text("css=div.activityBody span.activityContent")
    if text.length > 18 then bool = "true" 
		else bool = ""
	end
    begin
        assert_equal "true", bool, "Unable to verify the blogroll contains any visible content in on MyIGN's 'My Profile' page"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	
	#Check 'Games Followed' and 'People Followed' text appears in right rail
	begin
		assert /Games Followed/ =~ @selenium.get_text("css=div#rightRail"), "Unable to verify the user's followed games appear in the right rail of the My IGN 'My Profile' page."
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	begin
		assert /People Followed/ =~ @selenium.get_text("css=div#rightRail"), "Unable to verify the user's followed people appear in the right rail of the My IGN 'My Profile' page."
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  
  end
end