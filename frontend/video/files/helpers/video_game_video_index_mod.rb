
module VideoGameVideoIndexMod

  def check_game_header(page)
	#CHECK GAME HEADER PRESENT
	begin
		assert @selenium.is_element_present("css=div#header-wrapper div.contentHead"), "Unable to verify the game header is present on the following game video index #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	if @selenium.is_element_present("css=div#header-wrapper div.contentHead h2.contentTitle a")
		#CHECK GAME TITLE IN GAME HEADER HAS TEXT 
		begin
			assert @selenium.get_text("css=div#header-wrapper div.contentHead h2.contentTitle a").length > 1, "Unable to verify the game title in the game header contains text on the following game video index #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else
		#CHECK GAME TITLE WITH LINK IS PRESENT IN GAME HEADER
		begin
			assert @selenium.is_element_present("css=div#header-wrapper div.contentHead h2.contentTitle a"), "Unable to verify the game title and link in the game header is present on the following game video index #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end	
	end
  end
  
  def check_game_nav(page)
	
	nav_items = {"1"=>"Game Highlights", "2"=>"Review", "3"=>"Videos", "4"=>"Images", "5"=>"Guide", "6"=>"Walkthrough", "7"=>"Cheats", "8"=>"All Articles", "9"=>"Downloads" , "10"=>"Message Boards"}
		
	nav_items.each_pair do |k,v|
		begin
			assert @selenium.is_element_present("css=div#header-wrapper ul.contentNav li:nth-child(#{k}) > a"), "Unable to verify the #{v} link is present in the game nav on the following page #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def iterate_through_blogroll_nav_and_check_blogroll_entries_on_game_video_index(page)
	
	blogroll_items = {"1"=>"Recent Videos","2"=>"Top Videos","3"=>"Reviews","4"=>"Trailers","5"=>"Guides","6"=>"Gameplay","7"=>"Features"}
  
	(blogroll_items).each_pair do |k,v|
		@selenium.click("css=div#video-blogroll ul li:nth-child(#{k}) > a")
		sleep 5
		#CHECK ALL BLOGROLL SORT HAS AT LEAST ONE VIDEO
		begin
			assert @selenium.get_xpath_count("//div[@id='video-blogroll'] /div[contains(@class,'alpha')]").to_i > 0, "Unable to verify at least one video is being populated when the game's video-index blogroll is sorted by #{v}. Failure on #{@selenium.get_location}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		#CHECK EACH BLOGROLL ENTRY POINTING TO VIDEO PLAYER PAGE AND HAS TITLE
		(2..@selenium.get_xpath_count("//div[@id='video-blogroll'] /div[contains(@class,'alpha')]").to_i+1).each do |i|	
			entry_num = i-1
			sort = @selenium.get_text("css=div#video-blogroll ul li:nth-child(#{k}) > a")
			check_blogroll_entry_title_links_to_video_player_page(sort, entry_num, i)
			check_blogroll_entry_title_contains_text(sort, entry_num, i)
		end
		#CHECK MORE VIDEOS BUTTON POPULATES MORE VIDEOS
		if k==1
			check_more_blogroll_videos(v)
		end
	end
  end	
	
  def check_more_blogroll_videos(sort)
	if @selenium.is_element_present("css=a#moreVideos")
		initial_blogroll_count = @selenium.get_xpath_count("//div[@id='video-blogroll'] /div[contains(@class,'alpha')]")
		@selenium.click("css=a#moreVideos")
		sleep 5
		begin
			assert initial_blogroll_count < @selenium.get_xpath_count("//div[@id='video-blogroll'] /div[contains(@class,'alpha')]"), "Unable to verify the moreVideos button populates more blogroll entries when sorted by #{sort}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_right_rail_game_details(page)
	#CHECK BOX ART PRESENT AND IS A LINK
	begin
		assert @selenium.is_element_present("css=div#right-column div#detailsbox div a img[src*='http']"), "Unable to verify the game details box in the right rail is present and has a box art image that is linked. Failure on the following page #{page}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	#CHECK GAME DETAILS HAS SIGNIFICANT TEXT
	if @selenium.is_element_present("css=div#right-column div#detailsbox div ul li")
		begin
			assert @selenium.get_text("css=div#right-column div#detailsbox div ul li").length > 20, "Unable to verify the game details box in the right rail contains the game's information. Failure on the following page #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else
		begin
			assert @selenium.is_element_present("css=div#right-column div#detailsbox div ul li"), "Unable to verify the game details box in the right rail shows the game's information. Failure on the following page #{page}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end	
	end
  end

end