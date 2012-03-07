require 'date'
##################################################
#
# This is the helper file for the /prime-receipt page
#
###################################################


class VindiciaReceiptPage < Page
  
  	def is_displayed
   		puts "Is Receipt displayed?"
  		begin
  			if @client.find_element(:class,"prime-hdrtext").text.include? "Receipt"
  				puts "Yes!"
  				return true
  			else
  				puts @client.find_element(:class,"prime-hdrtext").text
  				raise "Receipt not displayed"
  			end
  		rescue Exception=>e
  			puts e
  		end
  	end
  	
  	def order_date
  		puts "Is order date correct?"
  		begin
  			t = Time.now
  			day = "%02d" % t.day
  			month = "%02d" % t.month
  			curr_date = "#{month}/#{day}/#{t.year}"
  			if @client.find_element(:id,"orderDateLabel").text.include? curr_date
  				puts "Yes!"
  				return true
  			else
  				raise "Order Date does not match!"
  			end
  		rescue Exception=>e
  			puts e
  			puts "Expected Date: #{curr_date}"
  			puts "Actual Date" + @client.find_element(:id,"orderDateLabel").text
  		end
  	end
  	
  	def account_name(name)
  		puts "Does account name match?"
  		begin
  			if @client.find_element(:id,"myIgnNicknameLabel").text.include? name
  				puts "Yes!"
  				return true
  			else
  				raise "Account name does not match!"
  			end
  		rescue Exception=>e
  			puts e
  			puts "Expected Account Name: #{name}"
  			puts "Actual Account Name" + @client.find_element(:id,"myIgnNicknameLabel").text
  		end
  	end
  	
  	def package_name(name)
  		puts "Does package name match?"
  		begin
  			if @client.find_element(:id,"packageNameLabel").text.include? name
  				puts "Yes!"
  				return true
  			else
  				raise "Package name does not match!"
  			end
  		rescue Exception=>e
  			puts e
  			puts "Expected Package Name: #{name}"
  			puts "Actual Package Name" + @client.find_element(:id,"packageNameLabel").text
  		end
  	end
  	
   	def package_price(price)
  		puts "Does package price match?"
  		begin
  			if @client.find_element(:id,"costLabel").text.include? price.to_s
  				puts "Yes!"
  				return true
  			else
  				raise "Package price does not match!"
  			end
  		rescue Exception=>e
  			puts e
  			puts "Expected Package Price #{price}"
  			puts "Actual Package Price" + @client.find_element(:id,"costLabel").text
  		end
  	end

end