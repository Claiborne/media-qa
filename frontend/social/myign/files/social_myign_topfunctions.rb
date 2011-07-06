require 'test/unit'
require 'rubygems'
gem 'selenium-client'
require 'selenium/client'
require 'files/helpers/social_myign_mod'
require 'net/http'
require 'json'


class SocialMyIGNTopFunctions < Test::Unit::TestCase

  include SocialMyIGNMod
  
  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*chrome",
      #:url => "http://www.ign.com/",
	  :url => "http://stg-my.ign.com/",
      :timeout_in_second => 60

    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end
  
  def test_social_myign_topfunctions
    
	#Go to MyIGN Home
	sign_in("smoke")
	@selenium.click("css=li#navItem-myign a.nav-lnk")
    @selenium.wait_for_page_to_load "40"
  
	#Status update
	status_update = rand_gen
	@selenium.type "css=input#statusField", "gui_test#{status_update}"
	@selenium.click("css=div#btnUpdateStatus")
	sleep 6
	
	#Check status update
	@selenium.refresh
	@selenium.wait_for_page_to_load "40"
	begin
      assert @selenium.get_text("css=ul#activityList").match(/#{status_update}/), "Unable to verify status update successful. (Update on made http://my.ign.com/home; unable to verify it appeared after waiting 6 seconds and refreshing the page)"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
	
	#Post on somenoe's wall
	wall_post = rand_gen
	@selenium.open("http://stg-people.ign.com/m_qa")
	@selenium.type "css=input#statusField", "gui_test#{wall_post}"
	@selenium.click("css=div#btnUpdateStatus")
	sleep 6
	
	#Check wall post
	@selenium.refresh
	@selenium.wait_for_page_to_load "40"
	begin
      assert @selenium.get_text("css=div#activityStream").match(/#{wall_post}/), "Unable to verify posting on someone's wall successful. (Wall post made on another users wall; unable to verify it appeared after waiting 6 seconds and refreshing the page)"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
	
	#Follow a person
	@selenium.click("css=div.myIgnFollowInstance")
	@selenium.click("css=div.addToIGN")
	sleep 6
	
	#Check folllow a person
	@selenium.open("http://stg-people.ign.com/clay.ign/people")
	begin
      assert_equal "M_QA", @selenium.get_text("css=ul#friendList a.peopleUsername"), "Unable to verify follow people function works (recently added person did not appear under the list of people following)"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
	
	#Follow a game
	@selenium.open("http://stg-people.ign.com/clay.ign")
	expected_games = @selenium.get_text("css=ul.profileStats li:nth-child(3) > div.value").to_i+1
	expected_games = expected_games.to_s

	@selenium.open("http://wii.ign.com/objects/143/14354707.html")
	@selenium.click("css=div.addToIGN")
	
	#Check follow a game: game-counter on profile increases by one
	@selenium.open("http://stg-people.ign.com/clay.ign")
	begin
      assert_equal expected_games, @selenium.get_text("css=ul.profileStats li:nth-child(3) > div.value"), "Unable to verify follow game function works (a released game was followed and the users profile game-counter did not increase by one"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
	
	#Comment on blog
	@selenium.open("http://www.ign.com/blogs/m_qa")
	@selenium.click("css=div#content div.post a.titlelink")
	@selenium.wait_for_page_to_load "40"
	sleep 6
	#blog_comment = rand_gen
	#@selenium.focus "css=div#comment"
	#@selenium.type_keys "css=div#comment", "gui_test#{blog_comment}"
	#@selenium.click("css=button#dsq-post-button")
	#sleep 6
	
	#Check blog comment: blog comment not visible on page refresh
	#@selenium.refresh
	#@selenium.wait_for_page_to_load "40"
	#begin
    #  assert @selenium.get_text("css=div.dsq-full-comment").match(/#{blog_comment}/), "Unable to verify posting comments on blogs work (blog comment not visible on page refresg)"
    #rescue Test::Unit::AssertionFailedError
    #  @verification_errors << $!
	#end
	
	#Check Disqus text field 
	begin
		assert @selenium.is_element_present("css=div.dsq-textarea iframe"), "Unable to verify the Disqus application is visible on blog article pages"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#Check Disqus comments
	begin
		assert @selenium.is_element_present("css=div.dsq-full-comment div[id*='dsq-comment-text-']"), "Unable to verify the Disqus comments are visible on blog article pages"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#Change profile avatar
	@selenium.open("http://stg-my.ign.com/user/settings")
	@selenium.click("css=button#chooseAvatar")
	!8.times{ break if (@selenium.is_element_present("css=div#avatarPicker")); sleep 1}
	if @selenium.is_element_present("css=div.avatar img[src*='xbox_360_controller.jpg']")
		@selenium.click("css=div#avatarPicker img[src*='ps3.jpg']")
		!8.times{ break if (@selenium.is_element_present("css=div#profilePicture img[src*='ps3.jpg']")); sleep 1}
		avatar_img = "ps3"
	elsif @selenium.is_element_present("css=div.avatar img[src*='ps3.jpg']")
		@selenium.click("css=div#avatarPicker img[src*='xbox_360_controller.jpg']")
		!8.times{ break if (@selenium.is_element_present("css=div#profilePicture img[src*='xbox_360_controller.jpg']")); sleep 1}
		@selenium.click("css=div#avatarPicker img[src*='xbox_360_controller.jpg']")
		!8.times{ break if (@selenium.is_element_present("css=div#profilePicture img[src*='xbox_360_controller.jpg']")); sleep 1}
		avatar_img = "xbox"
	end
	@selenium.click("css=button.positiveActionButton")
	@selenium.click("css=a#fancybox-close")
	sleep 6
	
	#Check image changed
	@selenium.open("http://stg-people.ign.com/clay.ign")
	if avatar_img == "xbox"
		begin
			assert @selenium.is_element_present("css=div.profilePicture img[src*='xbox_360_controller.jpg']"), "Unable to verify avatar picture change successful (the newly selected avatar pic did not appear on My Profile page"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	else	
		begin
			assert @selenium.is_element_present("css=div.profilePicture img[src*='ps3.jpg']"), "Unable to verify avatar picture change successful (the newly selected avatar pic did not appear on My Profile page"
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	
	#Switch to M_QA MyIGN Account for further verifications 
	log_out
	sign_in("qa")
	
	#Check Status Update
	@selenium.open("http://stg-people.ign.com/clay.ign")
	begin
		assert @selenium.get_text("css=ul#activityList").match(/#{status_update}/), "Unable to verify status update visible by another user when other user browsing updater's wall"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#Check wall post
	@selenium.open("http://stg-my.ign.com/home")
	begin
		assert @selenium.get_text("css=ul#activityList").match(/#{wall_post}/), "Unable to verify wall post update visible by another user when the other use browsing his MyIGN home page"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#Check folllow a person
	@selenium.open("http://stg-people.ign.com/m_qa/people")
	@selenium.click("css=li.followSetFollowers")
	!6.times{ break if (@selenium.is_element_present("css=li[class='followSetFollowers activeSet']")); sleep 1}
	sleep 2
	begin
		assert @selenium.get_text("css=ul#friendList").match("Clay.IGN"), "Unable to verify follow a person works"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#Reply to wall post
	@selenium.open("http://stg-my.ign.com/home")
	@selenium.click("css=div.activityBody a[id*='reply']")
	reply_txt = rand_gen
	sleep 1
	@selenium.click("css=ul#commentList textarea")
	@selenium.type_keys "css=ul#commentList textarea", reply_txt
	@selenium.click("css=ul#commentList div[id*='btnMakeComment']")

	#Check wall post comment
	log_out
	sign_in("smoke")
	@selenium.open("http://stg-people.ign.com/clay.ign")
	begin
		assert @selenium.get_text("css=div#bodyModulesContainer").match(/#{reply_txt}/), "Unable to verify replying to wall posts work (reply not visible)"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	#Clean up
	log_out
	sign_in("smoke")
	@selenium.open("http://wii.ign.com/objects/143/14354707.html")
	@selenium.click("css=div.addToIGN")
	@selenium.click("css=div.removeFromIGN") #unfollow DK
	
	@selenium.open("http://stg-people.ign.com/clay.ign/people")
	@selenium.click("css=a.removePersonLink") #unfollow m_qa
	
	#Check unfollows work
	sleep 6
	@selenium.open("http://stg-people.ign.com/clay.ign/people")
	@selenium.refresh
	
	begin
		assert !@selenium.get_text("css=ul#friendList").match("Clay.IGN"), "Unable to verify unfollowing a person works"
	rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
	end
	
	begin
      assert_not_equal expected_games, @selenium.get_text("css=ul.profileStats li:nth-child(3) > div.value"), "Unable to verify unfollowing a games works"
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
	
	#Block a user
	log_out
	sign_in("qa")
	@selenium.open("http://stg-my.ign.com/home") 
	@selenium.click("css=span.blockThisBitch")
    assert /has been blocked/ =~ @selenium.get_alert
	sleep 8
	
	#Check block prevents wall posting
	log_out
	sign_in("smoke")
	@selenium.open("http://stg-people.ign.com/m_qa")
	begin
        assert !@selenium.is_element_present("css=input#statusField"), "Unable to verify blocking a user prevents that user from posting on your wall"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	#Unblock
	log_out
	sign_in("qa")
	@selenium.open("http://stg-my.ign.com/settings")
	@selenium.click("css=ul#blockedUserList div.unblock")
	sleep 8
	
	#Check unblock allows wall posting
	log_out
	sign_in("smoke")
	@selenium.open("http://stg-people.ign.com/m_qa")
	begin
        assert @selenium.is_element_present("css=input#statusField"), "Unable to verify unblocking a person allows that person to post on your wall again"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
	
	#Make a new user
	#http = Net::HTTP.new("fedreg-api.ign.com")

	#request = Net::HTTP::Post.new("/3.0/FedRegService.svc/users/json", {'Content-Type' => 'application/json'} )
	
	#email_val = "hello"+(rand(10000000)+100).to_s+"@hello.com"
	#password_val = (rand(10000000)+10000).to_s
	#username_val = "a"+(rand(10000000)+100).to_s
	
	
	#request.body = 
	#{
	#"AppKey" => "www.ign.com", 
	#"Email" => email_val, 
	#"Password" => password_val,
	#"Nickname" => username_val
	#}.to_json

	#response = http.request(request)
	#sleep 8
	
	#Add a gamercard
	#@selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    #@selenium.click "emailField"
    #@selenium.type "emailField", email_val
    #@selenium.type "passwordField", password_val
    #@selenium.click "signinButton"
    #@selenium.wait_for_page_to_load "40"
	#open("http://people.ign.com/#{username_val}")
	#@selenium.click "NewIdBtn"
    #@selenium.type "css=li#Editrow input.platformId", "SolidBorne"
    #@selenium.click "slctone"
    #@selenium.click "psn"
    #@selenium.click "SaveIdBtn"
	#sleep 8
	
	#Check gamercard
	#open("http://stg-people.ign.com/#{username_val}")
	#begin
	#	assert /gameID/ =~ @selenium.get_text("css=ul#activityList"), "Unable to verify adding a gamercard though the header of a user's My Profile page generates an activity in the Activity/content roll below"
    #rescue Test::Unit::AssertionFailedError
	#	@verification_errors << $!
    #end
	#sleep 9
	
  end
end