
module SocialCheatsObjMod

  def signin
	@selenium.open "http://my.ign.com/login?r=http://www.ign.com/#"
    @selenium.click "emailField"
    @selenium.type "emailField", "qatest@testign.com"
    @selenium.type "passwordField", "testpassword"
    @selenium.click "signinButton"
    @selenium.wait_for_page_to_load "40"
  end
  
  def open_cheat_page
	@selenium.open "http://www.ign.com/cheats/games/pokemon-black-nintendo-ds-59687"
	@selenium.wait_for_page_to_load "40"
  end
  
  def type_title_and_body
	@selenium.type "css=input#title", "qa sanity/functional/regression check"
	@selenium.type "css=body#tinymce", "functional and regression test for cheats submission"
  end
  
  def cheat_open_type
	@selenium.click "css=a#control"
	assert !6.times{ break if (@selenium.is_visible("css=div#light") rescue false); sleep 1 }, "Unable to verify the cheat-submission lightbox become visible after clicking 'Submit a cheat for this game'"

	type_title_and_body
  end
  
  def submit
	@selenium.click "css=input#submit_btn"
  end
  
  def verify_submission
	assert !6.times{ break if (@selenium.is_visible("css=div[class='resultsBox grid_20']") rescue false); sleep 1 }, "Unable to verify the cheat-submission-confirmation lightbox became visible after submitting a cheat"
    begin
        assert /^[\s\S]*Thanks for the cheat[\s\S]*$/ =~ @selenium.get_text("css=div[class='resultsBox grid_20']"), "Unable to verify 'Thanks for the cheat' confirmation text after submitting a cheat"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
	end
	begin
        assert @selenium.is_element_present("css=a.anotherLink"), "Unable to verify 'Got another one?' link present after submitting a cheat"
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
  end

  def cheat_type (type)
    @selenium.click "css=input[value='"+type+"']"
  end
  
  def another_cheat
	@selenium.click "css=a.anotherLink"
	assert !6.times{ break if (@selenium.is_visible("css=div#light") rescue false); sleep 1 }, "Unable to verify the cheat-submission lightbox become visible after sumbitting a cheat and then clicknig, 'I have another one'"
  end
end