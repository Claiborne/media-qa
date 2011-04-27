class SubscribePage < Page
  
  include ScreenshotHelper
  
  def visit(url)
    @client.open(url)
  end

  def select_subscription_type(plan_name)
    case plan_name
      when "IGN Prime Monthly"
        plan_id = "plan-b5148149-4597-4dc1-815d-57741f0837d7"
      when "IGN Prime Annual"
        plan_id = "plan-cb36ec6d-addc-4846-91da-7b6ce725f227"
      when "IGN Prime Biannual" || "Prime 2 Year"
        plan_id = "plan-33a2fe7a-2a6d-440b-8f24-4310f77d55d3"
    end
    @client.click plan_id
  end

  def register_account(info)
    @client.type      "_ctl0_PageBody_signupPage_loginControl_emailTextBox",        info[:email]
    @client.fire_event  "_ctl0_PageBody_signupPage_loginControl_emailTextBox",      "blur"
    @client.type      "_ctl0_PageBody_signupPage_loginControl_passwordTextBox",     info[:password]
    @client.type      "_ctl0_PageBody_signupPage_loginControl_uniqueNickTextBox",   info[:unique_nick]
    @client.fire_event  "_ctl0_PageBody_signupPage_loginControl_uniqueNickTextBox", "blur"
  end

  def login_existing_account(username, password)


  end

  def select_payment_type(payment_type)
    case payment_type
      when "Visa" 
        payment_type = "payImage4"
      when "Amex" 
        payment_type = "payImage3"
      when "Mastercard"
        payment_type = "payImage5"
      when "Discover"
        payment_type = "payImage6"
      when "PayPal"
        payment_type = "payImage7"    
    end   
    @client.click payment_type
  end

  def fill_creditcard_details(info)
    puts "using card number"
    puts info[:card_num]
    @client.type    "cardNumberTextBox",                                                    info[:card_num]
    @client.type    "_ctl0_PageBody_signupPage_paymentControl_verificationNumberTextBox",   info[:card_cvv]
    @client.type    "_ctl0_PageBody_signupPage_paymentControl_firstNameTextBox",            info[:firstname]
    @client.type    "_ctl0_PageBody_signupPage_paymentControl_lastNameTextBox",             info[:lastname]
    @client.type    "_ctl0_PageBody_signupPage_paymentControl_address1TextBox",             info[:street_address]
    @client.type    "_ctl0_PageBody_signupPage_paymentControl_cityTextBox",                 info[:city]
    #picks a random zip code from the array. Scales as new zip codes are added.
    @client.type    "_ctl0_PageBody_signupPage_paymentControl_zipTextBox",                  info[:card_zip]
    @client.fire_event "_ctl0_PageBody_signupPage_paymentControl_zipTextBox",               "blur"
    #inputs a random CC expiration date
    @client.select    "_ctl0_PageBody_signupPage_paymentControl_expMonthDropDownList",      "label=" + info[:card_month]
    @client.select    "_ctl0_PageBody_signupPage_paymentControl_expYearDropDownList",       "label=" + info[:card_year]
  end

  def fill_paypal_details(info)

  end

  def complete_order
    @client.click "_ctl0_PageBody_signupPage_completeButton"

    #sometimes the blur event doesn't fire correctly for the zip code validation
    #this while loop fire the blur event for client side validation and hit the complete button
    #this will occur until the "Errors were detected." text no longer appears, at which point we assume the user is
    #advancing to the product page
    attempts = 0
    while @client.is_text_present("Errors were detected.")
      @client.fire_event "_ctl0_PageBody_signupPage_paymentControl_zipTextBox", "blur"
      sleep 1
      @client.click "_ctl0_PageBody_signupPage_completeButton"
      #limit the loop to 3 attempts. If it goes beyond the limit then break out of the while loop
      attempts = attempts + 1
      break if attempts == 3
    end
  end

  def assert_progress_page
    @client.wait_for_page_to_load('30000')    
    assert_element("_ctl0_PageBody_waitPage_progressBarControl_progressBarImage")
  end
  
  def logout
    @client.click "_ctl0_PageBody_signupPage_loginControl_logoutHyperLink"
    sleep 10
  end

  def assert_order_success(plan_name, unique_nick)
    case plan_name
      when "IGN Prime Monthly"
        plan_price = '6.95'
      when 'IGN Prime Annual'
        plan_price = '49.95'
      when 'IGN Prime Binnual'
        plan_price = '79.95'
    end
    #wait for "Receipt" to appear on page then run through assertions
    # Assertions:
    # 1) "Receipt" text appears on page
    # 2) The nickname the user chose on signup.aspx appears on the receipt
    # 3) The subscription package the user signed up for appears
    # 4) The correct price for the package was charged to the user
    # 5) Checkboxes for ad toggling and email signups appear
    @client.wait_for_page_to_load("30000")        
    assert_text(unique_nick)
    assert_text(plan_name)
    assert_text(plan_price)
    assert_text("Block intrusive ads on all IGN sites")
    assert_text("IGN Prime New Releases")
    assert_text("Email me VIP Events Announcements")
  end
  
  def generate_random_zip
    random_zip = Array[ "92626", "85004", "60448", "53024", "98109", "48405", "33634", "58203"]
    return random_zip[rand(random_zip.length - 1)]
  end
  
  def generate_random_cvv
    return rand(4000) + 1000    
  end
  
  def generate_random_month
    random_month = rand(11) + 1
    return random_month.to_s
  end
  
  def generate_random_year
    time_var = Time.now
    random_year = rand(10) + time_var.year + 1
    return random_year.to_s
  end
  
  def generate_card_num(cc_type)
    case cc_type
      when "Visa"
        card_num = Array['4444444444444448', '4012888888881881']
      when "Mastercard"
        card_num = Array['5555555555555557', '5555555555554444', '5105105105105100']
      when "Amex"
        card_num = Array['343434343434343', '371449635398431', '378282246310005']
      when "Discover"
        card_num = Array['6011111111111117', '6011000990139424']
    end
    return card_num[rand(card_num.length - 1)]
  end
end