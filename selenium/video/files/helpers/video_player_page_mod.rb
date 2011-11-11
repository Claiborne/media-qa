
module VideoPlayerPageMod
  
  def check_video_title_present
	begin
		assert @selenium.get_text("css=div#video-header h1").gsub(/[^a-zA-Z]/, "").length > 5, "Unable to verify a video title is present. Failed on the the following video-player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_video_player_present
	begin
		assert @selenium.is_element_present("css=div#flashVideo object#IGNPlayer[data*='http://media.ign.com/']"), "Unable to verify the video player is present. Failed on the following video-player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_video_player_sub_display_present
	begin
		assert @selenium.is_element_present("css=div#videoPlayer-sub div.video-caption"), "Unable to verify the video player's sub display is present. Failed on the following video-player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
	begin
		assert @selenium.is_element_present("css=div#videoPlayer-sub div.video-share ul.video-sharebuttons a#videoembed"), "Unable to verify the video player's share buttons are present. Failed on the following video-player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
    end
  end
  
  def check_must_watch_videos
	(1..4).each do |child|
		#CHECK LINK AND THUMB IMG PRESENT
		begin
			assert @selenium.is_element_present("css=div#hotlist ul.video-row li:nth-child(#{child}) > div.thumb_bg a img.thumb[src*='http']"), "Unable to verify one of the 'Must Watch Videos' in the first row has an image and link. Failed on the following video player page #{@selenium.get_location}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_element_present("css=div#hotlist ul.video-row:nth-child(5) > li:nth-child(#{child}) > div.thumb_bg a img.thumb[src*='http']"), "Unable to verify one of the 'Must Watch Videos' in the second row has an image and link. Failed on the following video player page #{@selenium.get_location}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		#CHECK EACH VIDEO LINKS TO A VIDEO PAGE
		begin
			assert @selenium.get_attribute("css=div#hotlist ul.video-row li:nth-child(#{child}) > div.thumb_bg a@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify the #{child} video in the first row of the 'Must Watch Videos' links to a video page. Failed on the following video player page #{@selenium.get_location}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.get_attribute("css=div#hotlist ul.video-row:nth-child(5) > li:nth-child(#{child}) > div.thumb_bg a@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify the #{child} video in the second row of the 'Must Watch Videos' links to a video page. Failed on the following video player page #{@selenium.get_location}"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
  end
	
  def check_disqus_comment_box_present
	begin
		assert @selenium.is_element_present("css=div#comment[contenteditable='true']"), "Unable to verify the disqus comments box appears. Failed on the following video player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
		begin
		assert @selenium.is_element_present("css=div#dsq-form-area div#dsq-textarea-wrapper iframe"), "Unable to verify the disqus comments box appears. Failed on the following video player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end 
  
  def check_disqus_comments_present
	begin
		assert @selenium.is_element_present("css=div#dsq-content ul#dsq-comments"), "Unable to verify the disqus comments appears. Failed on the following video player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	begin
		assert @selenium.is_element_present("css=div#dsq-content div#dsq-pagination"), "Unable to verify the disqus comments appears. Failed on the following video player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
  
  def check_right_rail_first_three_related_videos
	(1..2).each do |child|
		if @selenium.is_element_present("css=div#nextup ul.nextup-list li:nth-child(#{child})")
			begin
				assert @selenium.is_element_present("css=div#nextup ul.nextup-list li:nth-child(#{child}) > div.thumb_bg a img.thumb[src*='http']"), "Unable to verify the #{child} thumb in the 'Related Videos' widget has an image and link. Failed on the following video-player page #{@selenium.get_location}"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			begin
				assert @selenium.get_attribute("css=div#nextup ul.nextup-list li:nth-child(#{child}) > div.thumb_bg a@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify the #{child} thumb in the 'Related Videos' widget. Failed on the following page #{@selenium.get_location} links to a video-player page"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			begin
				assert @selenium.get_text("css=div#nextup ul.nextup-list li:nth-child(#{child}) > div.video-details ul li a").gsub(/[^a-zA-Z]/, "").length > 2, "Unable to verify the #{child} entry in the 'Related Videos' widget. Failed on the following page #{@selenium.get_location} contains a title"
			rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
			end
			begin
				assert @selenium.get_attribute("css=div#nextup ul.nextup-list li:nth-child(#{child}) > div.video-details ul li a@href").match(/\/videos\/\d{4}\/\d{2}\/\d{2}\/\S/), "Unable to verify the title of the #{child} entry in the 'Related Videos' widget. Failed on the following page #{@selenium.get_location} links to a video-player page"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		else
			begin
				assert @selenium.is_element_present("css=div#nextup ul.nextup-list li:nth-child(#{child}) > div.thumb_bg a img.thumb[src*='http']"), "Unable to verify the #{child} thumb in the 'Related Videos' widget has an image and link. Failed on the following video-player page #{@selenium.get_location}"
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		end
	end
  end
  
  def check_header_facebook_like_and_tweet_present
	begin
		assert @selenium.is_element_present("css=div#video-header div.shareThis a.addthis_button_facebook_like iframe") && @selenium.is_element_present("css=html#facebook a.connect_widget_like_button"), "Unable to verify the Facebook Like button is present in the header. Failed on the following video-player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	begin
		assert @selenium.is_element_present("css=div#video-header div.shareThis a.addthis_button_tweet iframe") && @selenium.is_element_present("css=div.addthis_tweet a.at_tb"), "Unable to verify the Tweet button is present in the header. Failed on the following video-player page #{@selenium.get_location}"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
  end
end