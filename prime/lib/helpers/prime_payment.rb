##################################################
#
# This is the helper file for the /prime-payment page
#
###################################################


class VindiciaPrimePayment < Page
  
  	#include ScreenshotHelper 
  	#include SqlServer

	def get_subscription_name
			return @client.find_element(:class, "selectedPackage").text
	end

	def change_subscription
		@client.find_element(:id, "subscribeLink").click
	end

	def choose_card_type(card_type)
		card_select = @client.find_element(:id => "vin_PaymentMethod_customerSpecifiedType")
		card_select.find_elements(:tag_name, "option").each do |option|
  		if option.attribute("value") == card_type
  			option.click
  		end
		end
		sleep 1
	end
	
	def fill_cc_details(info)
		@client.find_element(:id, "vin_PaymentMethod_creditCard_account").click
		@client.find_element(:id, "vin_PaymentMethod_creditCard_account").send_keys info[:card_num]
		@client.find_element(:id, "vin_PaymentMethod_nameValues_cvn").click
		@client.find_element(:id, "vin_PaymentMethod_nameValues_cvn").send_keys info[:card_cvv]
		#select exp month	
		month_select = @client.find_element(:id => "expirationMonth")
		month_select.find_elements(:tag_name, "option").each do |option|
  		if option.attribute("value") == info[:card_month]
  			option.click
  		end
		end
		#select exp year	
		year_select = @client.find_element(:id => "expirationYear")
		year_select.find_elements(:tag_name, "option").each do |option|
  		if option.attribute("value") == info[:card_year]
  			option.click
  		end
		end
		@client.find_element(:id, "vin_PaymentMethod_accountHolderName").send_keys info[:name]
		@client.find_element(:id, "vin_PaymentMethod_billingAddress_addr1").send_keys info[:street_address]
		@client.find_element(:id, "vin_PaymentMethod_billingAddress_city").send_keys info[:city]
		@client.find_element(:id, "vin_PaymentMethod_billingAddress_district").send_keys info[:state]
		@client.find_element(:id, "vin_PaymentMethod_billingAddress_postalCode").send_keys info[:zip_code]
	end
	
	def submit_order
		puts "submitting order"
		@client.find_element(:id, "completeBtn").click
	end
	
	def generate_card_num(cc_type)
    case cc_type
      when "Visa"
        card_num = Array['4444444444444448', '4012888888881881']
      when "Master Card"
        card_num = Array['5555555555555557', '5555555555554444', '5105105105105100']
      when "American Express"
        card_num = Array['343434343434343', '371449635398431', '378282246310005']
      when "Discover"
        card_num = Array['6011000990139424']
    end
    puts card_num[rand(card_num.length - 1)]
    return card_num[rand(card_num.length - 1)]
  end
  
  def generate_random_zip
    random_zip = Array[ "92626", "85004", "60448", "53024", "98109", "48405", "33634", "58203", "94107"]
    return random_zip[rand(random_zip.length - 1)]
  end
  
  def generate_random_cvv
    return rand(4000) + 1000    
  end
  
  def generate_random_month
    random_month = "%02d" % (rand(11) + 1) #%02d adds a leading 0
    return random_month.to_s
  end
  
  def generate_random_year
    time_var = Time.now
    random_year = rand(10) + time_var.year + 1
    return random_year.to_s
  end
  
  def is_displayed
		puts "Is Payment Info Page displayed?"
  	begin
  		if @client.find_element(:class,"prime-hdrtext").text.include? "Payment Info"
 				puts "Yes!"
 				return true
 			else
 				raise "Payment Info Page page not displayed"
 			end
 		rescue Exception=>e
 			puts e
 		end
	end
end
