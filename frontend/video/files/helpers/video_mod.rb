
module VideoMod

  def sign_in
	@selenium.open "http://my.ign.com/login?r=http://www.ign.com/"
	@selenium.click "emailField"
	@selenium.type "emailField", "smoketest@testign.com"
	@selenium.type "passwordField", "testpassword"
	@selenium.click "signinButton"
	@selenium.wait_for_page_to_load "40"
  end
  
  def iterate_through_blogroll_nav_and_check_blogroll_entries
	blogroll_link_count = @selenium.get_xpath_count("//div[@id='video-blogroll']/ul/li/a")
	(1..blogroll_link_count.to_i).each do |x|
		@selenium.click("css=div#video-blogroll ul li:nth-child(#{x}) > a")
		sleep 5
		(2..11).each do |i|	
			entry_num = i-1
			sort = @selenium.get_text("css=div#video-blogroll ul li:nth-child(#{x}) > a")
			check_blogroll_entry_image_and_link(sort, entry_num, i)
			check_blogroll_entry_img_links_to_video_player_page(sort, entry_num, i)
			check_blogroll_entry_title_links_to_video_player_page(sort, entry_num, i)
			check_blogroll_entry_title_contains_text(sort, entry_num, i)
			check_blogroll_entry_blurb_contains_text(sort, entry_num, i)
		end
	end
  end

  def check_able_to_populate_blogroll_with_more_entries
	initial_count = @selenium.get_xpath_count("//div[@id='video-blogroll']/div[contains(@class,'grid_16')]").to_i
	@selenium.click("css=a#moreVideos")
	sleep 5
	begin
		assert_equal initial_count+15, @selenium.get_xpath_count("//div[@id='video-blogroll']/div[contains(@class,'grid_16')]").to_i, "Unable to verify the 'View Next 15 Videos' loads 15 more videos"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
		
  def check_still_able_to_populate_more_entries
	if @selenium.is_element_present("css=a#moreVideos")
		initial_count = @selenium.get_xpath_count("//div[@id='video-blogroll']/div[contains(@class,'grid_16')]").to_i
		@selenium.click("css=a#moreVideos")
		sleep 5
		begin
			assert_equal initial_count+15, @selenium.get_xpath_count("//div[@id='video-blogroll']/div[contains(@class,'grid_16')]").to_i, "Unable to verify the 'View Next 15 Videos' loads 15 more videos when clicked a second time"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else
		begin
			assert @selenium.is_element_present("css=@#moreVideos"), "Unable to verify the 'View Next 15 Videos' link is present after it has already been pressed"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
	
  def check_no_duplicates_in_blogroll
	links = Array.new
	blogroll_count = @selenium.get_xpath_count("//div[@id='video-blogroll']/div[contains(@class,'grid_16')]").to_i+1
	(2..blogroll_count).each do |i|
		if @selenium.is_element_present("css=div#video-blogroll div.alpha:nth-child(#{i}) > div a")
			links << @selenium.get_attribute("css=div#video-blogroll div.grid_16:nth-child(#{i}) > div a@href")
		end
	end
	links_unique = links.uniq
	check_dups = links.length - links_unique.length
	begin
		assert check_dups < 4, "Unable to verify the blogroll entries (when more entries are populated twice) are unique (compared by img thumb URLs). Failure on following page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_blogroll_entry_image_and_link(sort, entry_num, child)
	begin
		assert @selenium.is_element_present("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.thumb_bg a img.thumb[src*='http']"), "Unable to verify the #{entry_num} entry in the blogroll when sorted by #{sort} has an image with a link"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_blogroll_entry_img_links_to_video_player_page(sort, entry_num, child)
	@selenium.get_attribute("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.thumb_bg a@href")
	begin
		assert @selenium.get_attribute("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.thumb_bg a@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify the image in the #{entry_num} entry in the blogroll when sorted by #{sort} links to a video player page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_blogroll_entry_title_links_to_video_player_page(sort, entry_num, child)
	@selenium.get_attribute("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.thumb_bg a@href")
	begin
		assert @selenium.get_attribute("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.grid_12 h3 a@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify the title of the #{entry_num} entry in the blogroll when sorted by #{sort} links to a video player page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_blogroll_entry_title_contains_text(sort, entry_num, child)
	begin
		assert @selenium.get_text("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.grid_12 h3").gsub(/[^a-zA-Z]/, "").length > 2, "Unable to verify the title of the #{entry_num} entry in the blogroll when sorted by #{sort} contains text"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_blogroll_entry_blurb_contains_text(sort, entry_num, child)
	blurb_para = @selenium.get_text("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.grid_12 p.video-description")
	blurb_span = @selenium.get_text("css=div#video-blogroll div.grid_16:nth-child(#{child}) > div.grid_12 p.video-description span.publish-date")
	blurb = blurb_para.gsub(blurb_span, "")
	blurb = blurb.gsub(/[^a-zA-Z]/, "")
	begin
		assert blurb.length > 6, "Unable to verify the blurb of the #{entry_num} entry in the blogroll when sorted by #{sort} contains text"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_right_rail_most_recent_series
	if @selenium.is_element_present("css=div#recent-series")
		(2..5).each do |child|
			begin
				assert @selenium.is_element_present("css=div#recent-series div.series-vid:nth-child(#{child}) > div a.grid_4 img[src*='http']"), "Unable to verify the 'Most Recent Series' widget in the right rail is displaying and working correctly. Failed on the following page #{@selenium.get_location}"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		end
	end
  end
  
  def check_right_rail_promoted_video
	if @selenium.is_element_present("css=div#promotedVideo")
		begin
			assert @selenium.is_element_present("css=div#promotedVideo a.videoThumb[href*='http'] img[src*='http']"), "Unable to verify the 'Promoted Videos' widget in the right rail is displaying and working correctly. Failed on the following page #{@selenium.get_location}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_footer_more_videos_widget
	(1..4).each do |child|
		begin
			assert @selenium.is_element_present("css=div[class*='video-module bottom_1 grid_16 container'] ul.also-watched li:nth-child(#{child}) > div.thumb_bg a img.thumb[src*='http']"), "Unable to verify one of the videos in the footer widget has an image and link. Failed on the following video-player page #{@selenium.get_location}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.get_attribute("css=div[class='video-module bottom_1 grid_16 container'] ul.also-watched li:nth-child(#{child}) > div.thumb_bg a@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify one of the videos in the footer widget links to a video-player page. Failed on the following video-player page #{@selenium.get_location}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
  
  def check_most_popular_videos_top_widget
	#ITERATE THROUGH WIDGET SLOTS
	(1..4).each do |child|
	
		if @selenium.is_element_present("css=div#main-area div.video-module ul.most-popular li:nth-child(#{child}) > div.thumb_bg a img.thumb")
			#CHECK IMG THUMB LINKS TO VIDEO PAGE
			begin
				assert @selenium.get_attribute("css=div#main-area div.video-module ul.most-popular li:nth-child(#{child}) > div.thumb_bg a@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify the #{child} image slot of the 'Most Popular Videos' widget on the top of the page links to a video-player page"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		else
			#CHECK IMG THUMB W/ LINK PRESENT
			begin
				assert @selenium.is_element_present("css=div#main-area div.video-module ul.most-popular li:nth-child(#{child}) > div.thumb_bg a img.thumb"), "Unable to verify the #{child} slot of the 'Most Popular Videos' widget on the top of the page has an image thumb with a link"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		end
		
		if @selenium.is_element_present("css=div#main-area div.video-module ul.most-popular li:nth-child(#{child}) > a.video-title")
			#CHECK TEXT TITLE LINKS TO VIDEO PAGE
			begin
				assert @selenium.get_attribute("css=div#main-area div.video-module ul.most-popular li:nth-child(#{child}) > a.video-title@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify the #{child} text slot of the 'Most Popular Videos' widget on the top of the page links to a video-player page"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		else
			#CHECK TEXT TITLE W/ LINK PRESENT
			begin
				assert @selenium.is_element_present("css=div#main-area div.video-module ul.most-popular li:nth-child(#{child}) > a.video-title"), "Unable to verify the #{child} slot of the 'Most Popular Videos' widget on the top of the page has an text title with a link"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		end
	end
  end
  
  def check_right_rail_facebook_like_and_tweet_present
	begin
		assert @selenium.is_element_present("css=div#right-column div.shareThis a.addthis_button_facebook_like iframe") && @selenium.is_element_present("css=html#facebook a.connect_widget_like_button"), "Unable to verify the Facebook Like button is present in the header. Failed on the following video-player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	begin
		assert @selenium.is_element_present("css=div#right-column div.shareThis a.addthis_button_tweet iframe") && @selenium.is_element_present("css=div.addthis_tweet a.at_tb"), "Unable to verify the Tweet button is present in the header. Failed on the following video-player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
end