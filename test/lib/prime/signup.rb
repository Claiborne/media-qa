require "page"

class SignupPage < Page
  def open
    @client.open("#{@config.options['baseurl']}/subscribe/signup.aspx")  
  end
  
  def login(info)
    @client.click("login")
    @client.type("_ctl0_PageBody_signupPage_loginControl_overlayEmailTextBox",    info[:email])
    @client.type("_ctl0_PageBody_signupPage_loginControl_overlayPasswordTextBox", info[:password])
    @client.click("loginacct-btn")
    sleep 5 #todo make better
   end
   
  def register(info)
    @client.type("_ctl0_PageBody_signupPage_loginControl_emailTextBox", info[:email])
    @client.fire_event("_ctl0_PageBody_signupPage_loginControl_emailTextBox", "blur")
    @client.type("_ctl0_PageBody_signupPage_loginControl_passwordTextBox", info[:password])
    @client.fire_event("_ctl0_PageBody_signupPage_loginControl_passwordTextBox", "blur")
    @client.type("_ctl0_PageBody_signupPage_loginControl_uniqueNickTextBox", info[:nickname])
    @client.fire_event("_ctl0_PageBody_signupPage_loginControl_uniqueNickTextBox", "blur")
  end
  
  def fill_CC_details(info)
    @client.type        "cardNumberTextBox",                                                  info[:card_num]
    puts "using card number " + info[:card_num]
    @client.type        "_ctl0_PageBody_signupPage_paymentControl_verificationNumberTextBox", info[:card_cvv]
    @client.type        "_ctl0_PageBody_signupPage_paymentControl_firstNameTextBox",          info[:first_name]
    @client.type        "_ctl0_PageBody_signupPage_paymentControl_lastNameTextBox",           info[:last_name]
    @client.type        "_ctl0_PageBody_signupPage_paymentControl_address1TextBox",           info[:street_address]
    @client.type        "_ctl0_PageBody_signupPage_paymentControl_cityTextBox",               info[:city]
    @client.type        "_ctl0_PageBody_signupPage_paymentControl_zipTextBox",                info[:card_zip]
    @client.fire_event  "_ctl0_PageBody_signupPage_paymentControl_zipTextBox",                "blur"
    @client.select      "_ctl0_PageBody_signupPage_paymentControl_expMonthDropDownList",      "label=" + info[:card_month]
    @client.select      "_ctl0_PageBody_signupPage_paymentControl_expYearDropDownList",       "label=" + info[:card_year]
  end
  
  def complete_order
    @client.click("_ctl0_PageBody_signupPage_completeButton")
    #sometimes the blur event doesn"t fire correctly for the zip code validation
    #this while loop fire the blur event for client side validation and hit the complete button
    #this will occur until the "Errors were detected." text no longer appears, at which point we assume the user is
    #advancing to the progress page
    attempts = 0
    while @client.is_text_present("Errors were detected.")
      @client.fire_event("_ctl0_PageBody_signupPage_paymentControl_zipTextBox", "blur")
      sleep 1
      @client.click("_ctl0_PageBody_signupPage_completeButton")
      #limit the loop to 3 attempts. If it goes beyond the limit then break out of the loop
      attempts = attempts + 1
      break if attempts == 3
    end
    @client.wait_for_page_to_load("30000")
    return assert_element("_ctl0_PageBody_waitPage_progressBarControl_progressBarImage")
  end
  
  def validate_order(nickname)
    while !@client.is_text_present("Receipt")
      #sometimes the progress page will refresh if billing is slow
      #this while loop should prevent the suite from doing the
      #assertions prematurely
      sleep 5
      if @client.is_text_present("Processing Delayed")
        puts "Unable to complete transaction. Processing Delayed."
        return false
      end
    end
    
    validation = [
      assert_text(nickname),
      assert_text("Block intrusive ads on all IGN sites"),
      assert_text("IGN Prime New Releases"),
      assert_text("Email me VIP Events Announcements")
    ]
    
    validation.each do |assert|
      if !assert
        return false
      end
    end
    return true
  end  
  
  def generate_random_zip
    random_zip = Array[ "92626", "85004", "60448", "53024", "98109", "48405", "33634", "58203"]
    return random_zip[rand(random_zip.length - 1)]
  end
  
  def generate_random_cvv
    return rand(4000) + 1000    
  end
  
  def generate_random_month
    return (rand(11) + 1).to_s
  end
  
  def generate_random_year
    return (rand(10) + Time.now.year + 1).to_s
  end
  
  def generate_card_num(cc_type)
    case cc_type
      when "Visa"
        card_num = Array["4444444444444448", "4012888888881881"]
        payment_type = "payImage4"
      when "Mastercard"
        card_num = Array["5555555555555557", "5555555555554444", "5105105105105100"]
        payment_type = "payImage5"
      when "Amex"
        card_num = Array["343434343434343", "371449635398431", "378282246310005"]
        payment_type = "payImage3"
      when "Discover"
        card_num = Array["6011000990139424"]
        payment_type = "payImage6"
    end
    @client.click payment_type
    return card_num[rand(card_num.length - 1)]
  end  
end