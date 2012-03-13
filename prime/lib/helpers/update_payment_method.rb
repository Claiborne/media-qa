##################################################
#
# This is the helper file for the /prime-payment page
#
###################################################

class UpdatePaymentMethod < VindiciaPrimePayment

	def visit(baseurl)
		@client.get "http://#{baseurl}/update-payment-method"
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
