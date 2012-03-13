require 'vindicia'

#This is to prevent the savon client from spamming the terminal
def HTTPI.log(*args); end
Savon.configure do |config|
  config.log = false             # disable logging
  #config.log_level = :info      # changing the log level
  #config.logger = Rails.logger  # using the Rails logger
end

class VindiciaAPI
	def initialize
		Vindicia.authenticate('ign_soap', 'U1yEunNGN2B9C1gY0nXk0rafX9P1WSAk', :prodtest)
	end
	
	def get_account_name(merchant_id)
		return (Vindicia::Account.find(merchant_id)).name
	end
	
	def get_autobill_desc(email)
		autobill = Vindicia::AutoBill.fetch_by_email(email)
		return autobill[1][0].product.description
	end
	
	def verify_transaction(package_name, expected_name)
			puts "Does Transaction appear in CashBox?"
			if package_name.include? expected_name
				puts "Yes!"
			else
				puts "Transaction does not appear in CashBox!"
				puts "Expected Package: #{expected_name}"
				puts "Returned Package: #{package_name}"
			end
	end
	
	def get_new_payment_method(email)
		autobill = Vindicia::AutoBill.fetch_by_email(email)
		payment_method = autobill[1][0].payment_method.credit_card.account[0]
		case payment_method
		when "6"
			return "American Express"
		when "3"
			return "Visa"
		when "4"
			return "MasterCard"
		when "5"
			return "Discover"
		end
	end
	
	def get_current_payment_method(email)
		autobill = Vindicia::AutoBill.fetch_by_email(email)
		puts "current payment method #{autobill[1][0].payment_method.credit_card.account[0]}"
		case autobill[1][0].payment_method.credit_card.account[0]
		when "6"
			return "American Express"
		when "3"
			return "Visa"
		when "4"
			return "MasterCard"
		when "5"
			return "Discover"
		end
	end
	
	def get_last_four(email)
		autobill = Vindicia::AutoBill.fetch_by_email(email)
		puts "last four is #{autobill[1][0].payment_method.credit_card.last_digits}"
		return autobill[1][0].payment_method.credit_card.last_digits
  end

  def get_autobill_status(email)
    autobill = Vindicia::AutoBill.fetch_by_email(email)
    return autobill[1][0].status
  end
end