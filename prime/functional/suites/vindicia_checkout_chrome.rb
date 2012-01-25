require "rubygems"
gem "test-unit"
require "test/unit"
require "selenium-webdriver"
require "vindicia"

require "library"

class CheckoutCreditCard < Test::Unit::TestCase
  
	def setup
  	Browser.type = "Chrome"
  	@browser = Browser.new
    
  	@time = CustomTime.new
  	@time = @time.get_int_time
	end

	def teardown
  	@browser.shutdown()
  	assert_equal [], Page.errors
	end

	# def test_login
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
# 		
		# subscribe_page.visit
		# #notify(subscribe_page.logout)
		# subscribe_page.login_account({
			# :email		=>	"fklun-auto-test-2@ign.com",
			# :password	=>	"boxofass"
		# })
		# subscribe_page.continue
		# assert_true(subscribe_page.get_text("prime-hdrtext", "class").include? "Payment Info")
	# end
	
	# def test_registration
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# subscribe_page.logout
		# subscribe_page.visit
		# subscribe_page.register_account({
			# :email		=>	"fklun-auto-#{@time}@ign.com",
			# :password	=>	"boxofass",
			# :nickname	=>	"fklun-auto-#{@time}"
		# })
		# subscribe_page.continue
	# end

	# def test_subscription_name
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# payment_page = VindiciaPrimePayment.new
		# payment_page.client = @browser.client
# 		
		# subscribe_page.visit
		# #notify(subscribe_page.logout)
		# subscribe_page.select_subscription("IGN Prime Annual")
		# subscribe_page.login_account({
			# :email		=>	"fklun-auto-test-2@ign.com",
			# :password	=>	"boxofass"
		# })
		# subscribe_page.continue
		# assert_true(payment_page.get_subscription_name.include? "Prime - Annual")
	# end
	
	def test_visa_transaction_chrome
		subscribe_page = VindiciaSubscribePage.new
		subscribe_page.client = @browser.client
		payment_page = VindiciaPrimePayment.new
		payment_page.client = @browser.client
		receipt_page = VindiciaReceiptPage.new
		receipt_page.client = @browser.client
		
		subscribe_page.visit
		notify(subscribe_page.logout)
		subscribe_page.select_subscription("Prime - Annual")
		subscribe_page.register_account({
			:email		=>	"fk-auto-#{@time}@ign.com",
			:password	=>	"boxofass",
			:nickname	=>	"fk-auto-#{@time}"
		})
		subscribe_page.continue
		payment_page.choose_card_type("Visa")
		payment_page.fill_cc_details({
      :card_num         => payment_page.generate_card_num("Visa"),
      :card_cvv         => payment_page.generate_random_cvv,
      :name       			=> 'Frank Klun',
      :street_address   => '625 2nd. Street',
      :city             => 'San Francisco',
      :state						=> 'CA',
      :zip_code         => payment_page.generate_random_zip,
      :card_month       => payment_page.generate_random_month,
      :card_year        => payment_page.generate_random_year
      })    
    payment_page.submit_order
    assert_true(receipt_page.is_displayed)
    assert_true(receipt_page.order_date)
    assert_true(receipt_page.account_name("fk-auto-#{@time}"))
    assert_true(receipt_page.package_name("Prime - Annual"))
    
    #verify receipt
    #verify autobill created for account
    vindicia = VindiciaAPI.new
    package_name = vindicia.get_autobill_desc("fk-auto-#{@time}@ign.com")
    assert_true(vindicia.verify_transaction(package_name, "Prime-Annual"))
	end
	
	# def test_mastercard_transaction_chrome
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# payment_page = VindiciaPrimePayment.new
		# payment_page.client = @browser.client
# 		
		# subscribe_page.visit
		# #notify(subscribe_page.logout)
		# subscribe_page.select_subscription("IGN Prime Annual")
		# # subscribe_page.register_account({
			# # :email		=>	"fk-auto-#{@time}@ign.com",
			# # :password	=>	"boxofass",
			# # :nickname	=>	"fk-auto-#{@time}"
		# # })
		# subscribe_page.login_account({
			# :email		=>	"fklun-auto-test-2@ign.com",
			# :password	=>	"boxofass"
		# })
		# subscribe_page.continue
		# payment_page.choose_card_type("Mastercard")
		# payment_page.fill_cc_details({
      # :card_num         => payment_page.generate_card_num("Master Card"),
      # :card_cvv         => payment_page.generate_random_cvv,
      # :name       => 'Frank Klun',
      # :street_address   => '625 2nd. Street',
      # :city             => 'San Francisco',
      # :state						=> 'CA',
      # :zip_code         => payment_page.generate_random_zip,
      # :card_month       => payment_page.generate_random_month,
      # :card_year        => payment_page.generate_random_year
      # })    
    # payment_page.submit_order
	# end
# 	
	# def test_discover_transaction_chrome
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# payment_page = VindiciaPrimePayment.new
		# payment_page.client = @browser.client
# 		
		# subscribe_page.visit
		# #notify(subscribe_page.logout)
		# subscribe_page.select_subscription("IGN Prime Annual")
		# # subscribe_page.register_account({
			# # :email		=>	"fk-auto-#{@time}@ign.com",
			# # :password	=>	"boxofass",
			# # :nickname	=>	"fk-auto-#{@time}"
		# # })
		# subscribe_page.login_account({
			# :email		=>	"fklun-auto-test-2@ign.com",
			# :password	=>	"boxofass"
		# })
		# subscribe_page.continue
		# payment_page.choose_card_type("Discover")
		# payment_page.fill_cc_details({
      # :card_num         => payment_page.generate_card_num("Discover"),
      # :card_cvv         => payment_page.generate_random_cvv,
      # :name       => 'Frank Klun',
      # :street_address   => '625 2nd. Street',
      # :city             => 'San Francisco',
      # :state						=> 'CA',
      # :zip_code         => payment_page.generate_random_zip,
      # :card_month       => payment_page.generate_random_month,
      # :card_year        => payment_page.generate_random_year
      # })    
    # payment_page.submit_order
	# end
# 	
	# def test_amex_transaction_chrome
		# subscribe_page = VindiciaSubscribePage.new
		# subscribe_page.client = @browser.client
		# payment_page = VindiciaPrimePayment.new
		# payment_page.client = @browser.client
# 		
		# subscribe_page.visit
		# #notify(subscribe_page.logout)
		# subscribe_page.select_subscription("IGN Prime Annual")
		# # subscribe_page.register_account({
			# # :email		=>	"fk-auto-#{@time}@ign.com",
			# # :password	=>	"boxofass",
			# # :nickname	=>	"fk-auto-#{@time}"
		# # })
		# subscribe_page.login_account({
			# :email		=>	"fklun-auto-test-2@ign.com",
			# :password	=>	"boxofass"
		# })
		# subscribe_page.continue
		# payment_page.choose_card_type("AmEx")
		# payment_page.fill_cc_details({
      # :card_num         => payment_page.generate_card_num("American Express"),
      # :card_cvv         => payment_page.generate_random_cvv,
      # :name       => 'Frank Klun',
      # :street_address   => '625 2nd. Street',
      # :city             => 'San Francisco',
      # :state						=> 'CA',
      # :zip_code         => payment_page.generate_random_zip,
      # :card_month       => payment_page.generate_random_month,
      # :card_year        => payment_page.generate_random_year
      # })    
    # payment_page.submit_order
	# end
	
end