require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require "files/helpers/social_blog_format_module"


class SocialBlogVideoPost < Test::Unit::TestCase

  include SocialBlogFormatMod

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "qa-server",
      :port => 4444,
      :browser => "Firefox on Windows SSL OK",
      :url => "http://www.ign.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
	
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_social_blog_ign_video_embed
	new_post
	type_title
	
	# EMBED IGN VIDEO
	@selenium.type "tinymce", "[ignvideo url=\"http://www.ign.com/videos/2011/04/15/battlefield-3-my-life-trailer\"]"
	sleep 1
	
	preview
	# VIDEO APPEARS IN PREVIEW
	begin
		assert @selenium.is_element_present("css=div.entry object.ign-videoplayer"), "The IGN video player did not appear in the preview of the new blog entry"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	# VIDEO APPEARS IN API
	blogid = @selenium.get_attribute("css=div#content div[class='post type-post']@id")
	blogid = blogid.delete "post-"
	@selenium.open "http://api.ign.com/v2/articles/"+blogid+".json"
	@selenium.wait_for_page_to_load "40"
	begin
        assert @selenium.is_text_present("ignvideo url=\"http://www.ign.com/videos/2011/04/15/battlefield-3-my-life-trailer\""), "The IGN video does not appear in the content API"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
  
	@selenium.open "http://write.ign.com/Clay.IGN/wp-admin/post-new.php"
	@selenium.wait_for_page_to_load "40"
	type_title
	
	# EMBED IGN VIDEO
	@selenium.type "tinymce", "[youtube clip_id=\"EsbDa0SEnFE\"]"
	sleep 1
	
	preview
	# VIDEO APPEARS IN PREVIEW
	begin
		assert @selenium.is_element_present("css=div.entry object param[value*='youtube.com']"), "The Youtube video player did not appear in the preview of the new blog entry"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	# VIDEO APPEARS IN API
	blogid = @selenium.get_attribute("css=div#content div[class='post type-post']@id")
	blogid = blogid.delete "post-"
	@selenium.open "http://api.ign.com/v2/articles/"+blogid+".json"
	@selenium.wait_for_page_to_load "40"
	begin
        assert @selenium.is_text_present("youtube clip_id=\"EsbDa0SEnFE\""), "The Youtube video does not appear in the content API"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	@selenium.open "http://write.ign.com/Clay.IGN/wp-admin/post-new.php"
	@selenium.wait_for_page_to_load "40"
	type_title
	
	# EMBED IGN VIDEO
	@selenium.type "tinymce", "[vimeo clip_id=\"16776166\"]"
	sleep 1
	
	preview
	# VIDEO APPEARS IN PREVIEW
	begin
		assert @selenium.is_element_present("css=div.entry iframe[src*='http://player.vimeo.com/video/']"), "The Vimeo video player did not appear in the preview of the new blog entry"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	# VIDEO APPEARS IN API
	blogid = @selenium.get_attribute("css=div#content div[class='post type-post']@id")
	blogid = blogid.delete "post-"
	@selenium.open "http://api.ign.com/v2/articles/"+blogid+".json"
	@selenium.wait_for_page_to_load "40"
	begin
        assert @selenium.is_text_present("vimeo clip_id=\"16776166\""), "The Vimeo video does not appear in the content API"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
  end
end