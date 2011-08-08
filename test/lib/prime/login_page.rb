require "page"

class LoginPage < Page
  include WebService
  
  def disable_ads_on_ign
    disable_ads_for_user(@config.options['subscriber_id'])
    @client.open("http://#{@config.options['ign_baseurl']}")
    if assert_text('Log in with your email address.')
      @client.type  '_ctl0_PageBody__ctl0_existingInput_emailTextBox',    @config.options['subscriber_email']
      @client.type  '_ctl0_PageBody__ctl0_existingInput_passwordTextBox', 'boxofass'
      @client.click '_ctl0:PageBody:_ctl0:existingInput:logInButton'
      @client.wait_for_page_to_load '30000'
      #rare case but sometimes the user will need to choose a nickname
      if assert_text("The nickname you are currently using in your login profile is already in use by another IGN.com user.")
        @client.type '_ctl0_PageBody__ctl0_nickNameTextBox', "ignauto#{rand(500000)}"
        @client.click '_ctl0_PageBody__ctl0_tryAgainButton'
        @client.wait_for_page_to_load '30000'
      end
    end
    if assert_text 'Ads are enabled.'
      @client.click '_ctl0_PageBody__ctl0_manageAds_adsHyperLink'
      @client.wait_for_page_to_load '30000'
    end
    return assert_text 'Congratulations! You have disabled ads!'  
  end
  
  def disable_ads_on_fileplanet
    disable_ads_for_user(@config.options['subscriber_id'])
    @client.open("http://#{@config.options['fileplanet_baseurl']}")
    if assert_text('Log In With Email Address')
      @client.type  '_ctl0_PageBody__ctl0_existingInput_emailTextBox',    @config.options['subscriber_email']
      @client.type  '_ctl0_PageBody__ctl0_existingInput_passwordTextBox', 'boxofass'
      @client.click '_ctl0:PageBody:_ctl0:existingInput:logInButton'
      @client.wait_for_page_to_load '30000'
      #rare case but sometimes the user will need to choose a nickname
      if assert_text("The nickname you've selected is not available")
        @client.type '_ctl0_PageBody__ctl0_nickNameTextBox', "ignauto#{rand(500000)}"
        @client.click '_ctl0_PageBody__ctl0_tryAgainButton'
        @client.wait_for_page_to_load '30000'
      end
    end
    if assert_text 'Ads are enabled.'
      @client.click '_ctl0_PageBody__ctl0_manageAds_adsHyperLink'
      @client.wait_for_page_to_load '30000'
    end
    return assert_text 'Congratulations! You have disabled ads!'  
  end
  
  def disable_ads_on_gamespy
    disable_ads_for_user(@config.options['subscriber_id'])
    @client.open("http://#{@config.options['gamespy_baseurl']}")
    if assert_text('Log In With Email Address')
      @client.type  '_ctl0_PageBody__ctl0_existingInput_emailTextBox',    @config.options['subscriber_email']
      @client.type  '_ctl0_PageBody__ctl0_existingInput_passwordTextBox', 'boxofass'
      @client.click '_ctl0:PageBody:_ctl0:existingInput:logInButton'
      @client.wait_for_page_to_load '30000'
      #rare case but sometimes the user will need to choose a nickname
      if assert_text("The nickname you've selected is not available")
        @client.type '_ctl0_PageBody__ctl0_nickNameTextBox', "ignauto#{rand(500000)}"
        @client.click '_ctl0_PageBody__ctl0_tryAgainButton'
        @client.wait_for_page_to_load '30000'
      end
    end
    if assert_text 'Ads are enabled.'
      @client.click '_ctl0_PageBody__ctl0_manageAds_adsHyperLink'
      @client.wait_for_page_to_load '30000'
    end
    return assert_text 'Congratulations! You have disabled ads!'  
  end
end
