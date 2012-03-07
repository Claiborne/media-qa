require 'vindicia'

#This is to prevent the savon client from spamming the terminal
def HTTPI.log(*args); end
Savon.configure do |config|
  config.log = false             # disable logging
  #config.log_level = :info      # changing the log level
  #config.logger = Rails.logger  # using the Rails logger
end

class VindiciaAPI < Page 
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
end