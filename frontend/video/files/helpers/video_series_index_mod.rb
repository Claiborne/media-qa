
module VideoSeriesIndexMod
  
  def check_blogroll
	(2..4).each do |child|	
		if !@selenium.is_element_present("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a")
			#CHECK EACH ENTRY HAS A HEADER AND LINK
			begin
				assert @selenium.is_element_present("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a"), "Unable to verify the #{child-1} blogroll entry has a header and link"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		else 
			series_name = @selenium.get_text("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a")
			#CHECK EACH HEADER HAS TEXT
			begin
				assert @selenium.get_text("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a").length > 0, "Unable to verify the #{series_name} blogroll entry's header has text and a link"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			#CHECK EACH HEADER LINKS TO SERIES PAGE
			begin
				assert @selenium.get_attribute("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a@href").match(/\/videos\/series\/\S/), "Unable to verify the #{series_name} blogroll entry links to a series page"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		end
	end
	(6..32).each do |child|
		if !@selenium.is_element_present("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a")
			#CHECK EACH ENTRY HAS A HEADER AND LINK
			begin
				assert @selenium.is_element_present("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a"), "Unable to verify the #{child-2} blogroll entry has a header and link"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		else 
			series_name = @selenium.get_text("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a")
			#CHECK EACH HEADER HAS TEXT
			begin
				assert @selenium.get_text("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a").length > 0, "Unable to verify the #{series_name} blogroll entry's header has text and a link"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			#CHECK EACH HEADER LINKS TO SERIES PAGE
			begin
				assert @selenium.get_attribute("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.omega h3 a@href").match(/\/videos\/series\/\S/), "Unable to verify the #{series_name} blogroll entry links to a Series page"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		end
	end
  end
  
  def check_populate_more_blogroll_button
	if @selenium.is_element_present("css=a#moreVideos")
		initial_blogroll_count = @selenium.get_xpath_count("//div[@id='video-blogroll']/div[contains(@class,'alpha')]").to_i
		@selenium.click("css=a#moreVideos")
		sleep 5
		#CHECK MORE ENTIRES POPULATED
		begin
			assert initial_blogroll_count < @selenium.get_xpath_count("//div[@id='video-blogroll']/div[contains(@class,'alpha')]").to_i, "Unable to verify more blogroll entries were populated after clicking the 'View More Videos Series' button at the bottom of the blogroll"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		#CHECK NO DUPLICATES AFTER MORE ENTRIES POPULATED
		links = Array.new
		blogroll_count = @selenium.get_xpath_count("//div[@id='video-blogroll']/div[contains(@class,'alpha')]").to_i+1
		(2..blogroll_count).each do |i|
			if @selenium.is_element_present("css=div#video-blogroll div.alpha:nth-child(#{i}) > div a")
				links << @selenium.get_attribute("css=div#video-blogroll div.alpha:nth-child(#{i}) > div a@href")
			end
		end
		begin
			assert links.uniq! == nil, "Unable to verify all the blogroll entries (when more entries are populated) on the video series index are all unique (compared by img thumb URLs)"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else
		begin
			assert @selenium.is_element_present("css=a#moreVideos"), "Unable to verify the button to populate more blogroll entries is present"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_blogroll_when_sort_by_most_recent_videos
	@selenium.click("css=div#video-blogroll ul li:nth-child(2) > a")
	sleep 5
	(2..11).each do |i|	
		entry_num = i-1
		sort = @selenium.get_text("css=div#video-blogroll ul li:nth-child(2) > a")
		check_blogroll_entry_image_and_link(sort, entry_num, i)
		check_blogroll_entry_img_links_to_video_player_page(sort, entry_num, i)
		check_blogroll_entry_title_links_to_video_player_page(sort, entry_num, i)
		check_blogroll_entry_title_contains_text(sort, entry_num, i)
		check_blogroll_entry_blurb_contains_text(sort, entry_num, i)
	end
  end
  
end