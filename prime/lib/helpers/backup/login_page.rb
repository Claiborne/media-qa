require 'sqlserver'

class LoginPage < Page
  
  include ScreenshotHelper


  def login(login_info)
    if locate_text('Log In With Email Address')
      @client.type  '_ctl0_PageBody__ctl0_existingInput_emailTextBox',    login_info[:email]
      @client.type  '_ctl0_PageBody__ctl0_existingInput_passwordTextBox', login_info[:password]
      @client.click '_ctl0:PageBody:_ctl0:existingInput:logInButton'
      @client.wait_for_page_to_load '30000'
      #rare case but sometimes the user will need to choose a nickname
      if locate_text("The nickname you've selected is not available")
        @client.type '_ctl0_PageBody__ctl0_nickNameTextBox', "ignauto#{rand(500000)}"
        @client.click '_ctl0_PageBody__ctl0_tryAgainButton'
        @client.wait_for_page_to_load '30000'
      end      
    end      
  end
  
  def disable_ads
    assert_text 'Click Here to Disable Ads!'
    @client.click '_ctl0_PageBody__ctl0_manageAds_adsHyperLink'
    @client.wait_for_page_to_load '30000'
    assert_text 'Click Here to Enable Ads!'
  end
  
  def enable_ads
    assert_text 'Click Here to Enable Ads!'
    @client.click '_ctl0_PageBody__ctl0_manageAds_adsHyperLink'
    @client.wait_for_page_to_load '30000'
    assert_text 'Click Here to Disable Ads!'
  end
  
  def verify_domains(domain, status, login_info)
    @client.open(domain)
    login(login_info)
    #determine whether we need to check if ads are disabled or enabled and then run an assert_text
    case status
      when 'enabled'
        assert_text('Click Here to Disable Ads!')
      when 'disabled'
        assert_text('Click Here to Enable Ads!')
    end
  end

  def verify_hub_page(status, login_info)
    @client.open("http://dev.login.ign.com/prime/hub.aspx")
    #if user isn't logged in then lets log them in
    if @client.is_text_present('Log In With Email Address')
      login(login_info)
    end  
    case status
      when 'enabled'
        assert_element_not_present("//ul[@id='member-settings']/li[1]/label[@class='checked']")
      when 'disabled'
        assert_element("//ul[@id='member-settings']/li[1]/label[@class='checked']")
    end    
  end
  
  def verify_sub_api(status, user_email)
    #@reportLog.puts("Verifying ads are disabled on subAPI\n")
    #url = URI.parse("http://dev.subscriptionservices.ign.com")
    user_id = get_user_id(user_email)
    #Net::HTTP.start(url.host, url.port) {|http| http.get("/1.0/FeatureCheckService.svc/web/AdsAreDisabledCheck/xml/#{user_id}") }
    visit("http://dev.subscriptionservices.ign.com/1.0/FeatureCheckService.svc/web/AdsAreDisabledCheck/xml/#{user_id}")
    case status
      when 'enabled'
        assert_text('false')
      when 'disabled'
        puts @client.get_location
        sleep 15
        assert_text('true')
    end
  end  
  
  def get_user_id(user_email)
    #@reportLog.puts("Retrieving userID\n")
    #creates a new db object using our dev sql server
    db = SqlServer.new('igndevsql01.las1.colo.ignops.com')
    #opens the Gametrack DB which contains all the user information
    db.open('Gametrack')
    #queries the database and extracts the userID from a given email address
    user_id = db.query("SELECT userid from users WHERE email ='#{user_email}';")
    puts "user email is #{user_email}"
    puts "userid is #{user_id}"
    user_id.to_s
    #user_id = user_id.match(/\[\[(.*)\]\]/)  
    puts user_id
    
    #puts "userid is #{user_id}"
    #close the database connection and returns the userID
    db.close
    return user_id
  end  
end