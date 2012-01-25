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
		return autobill[1][0].billing_plan.description
	end
	
	def verify_transaction(package_name, expected_name)
		begin
			return package_name.include? expected_name
		rescue
			puts "Transaction not verified in CashBox"
			puts "Expected Package: #{expected_name}"
			puts "Returned Package: #{package_name}"
			return false
		end
	end
end