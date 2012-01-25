require 'date'
##################################################
#
# This is the helper file for the /prime-receipt page
#
###################################################


class VindiciaReceiptPage < Page
  
  	def is_displayed
  		begin
  			return @client.find_element(:class,"prime-hdrtext").text.include? "Receipt"
  		rescue
  			puts "Receipt Page could not be found"
  			return false
  		end
  	end
  	
  	def order_date
  		begin
  			return @client.find_element(:id,"orderDateLabel").text.include? Time.now.to_s
  		rescue
  			puts "Order date is not correct"
  			return false
  		end
  	end
  	
  	def account_name(name)
  		begin
  			return @client.find_element(:id,"myIgnNicknameLabel").text.include? name
  		rescue
  			puts "Account Name does not match"
  			return false
  		end
  	end
  	
  	def package_name(name)
  		begin
  			return @client.find_element(:id,"packageNameLabel").text.include? name
  		rescue
  			puts "Package Name does not match"
  			return false
  		end
  	end

end