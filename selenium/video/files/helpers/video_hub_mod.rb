
module VideoHubMod

  def check_url_is_video_hub 
    #Check "Vidoes" in global nav loads "http://www.ign.com/videos/"
	begin
		assert_equal @selenium.get_location, "http://www.ign.com/videos/", "Unable to verify clicking on 'Videos' in the global nav loads 'http://www.ign.com/videos/'"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_three_featured_vids
	#Check the three featured videos each contain a link and img
	featured_hub_vids = ["li.grid_8 a img[src*=http]", "li:nth-child(2).grid_8 a img[src*=http]", "li:nth-child(3).grid_8 a img[src*=http]"]
	featured_hub_vids.each do |i|
		begin
			assert @selenium.is_element_present("css=div#video-hub #{i}"), "Unable to verify one of the three featured videos on the top of the hub page contains a link and image"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_blogroll_entry_date_is_within_2_days
	begin
		assert Date.parse(@selenium.get_text("css=div#video-blogroll div.grid_16:nth-child(3) > div.grid_12 p.video-description span.publish-date")) > Date.today-2, "Unable to verify recent videos are being uploaded to the Video Hub page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_blogroll_nav_count_atleast_4(count)
	begin
		assert count.to_i > 3, "Unable to verify the blogroll nav on the video hub page is displaying all the nav links"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
end