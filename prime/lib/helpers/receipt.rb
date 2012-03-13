##################################################
#
# This is the helper file for the /prime-receipt page
#
###################################################

require 'date'

class VindiciaReceiptPage < Page

  	def is_displayed
      @@report.suite_begin()
   		@@report.step("Is Receipt displayed?")
  		begin
  			if @client.find_element(:class,"prime-hdrtext").text.include? "Receipt"
          @@report.step("Yes!")
  				return true
  			else
  				raise "Receipt not displayed"
  			end
      rescue Exception=>e
  			@@report.step("#{e}")
        @@report.step("Current Page is: " + @client.find_element(:class,"prime-hdrtext").text + "")
        @@report.suite_end()
      end
  	end
  	
  	def order_date
  		@@report.step("Is order date correct?")
  		begin
  			t = Time.now
  			day = "%02d" % t.day
  			month = "%02d" % t.month
  			curr_date = "#{month}/#{day}/#{t.year}"
  			if @client.find_element(:id,"orderDateLabel").text.include? curr_date
  				@@report.step("Yes!")
  				return true
  			else
  				raise "Order Date does not match!"
  			end
  		rescue Exception=>e
  			@@report.step("#{e}")
  			@@report.step("Expected Date: #{curr_date}")
  			@@report.step("Actual Date" + @client.find_element(:id,"orderDateLabel").text + "</div>")
        @@report.suite_end()
  		end
  	end
  	
  	def account_name(name)
  		@@report.step("Does account name match?")
  		begin
  			if @client.find_element(:id,"myIgnNicknameLabel").text.include? name
  				@@report.step("Yes!")
  				return true
  			else
  				raise "Account name does not match!</div>"
  			end
  		rescue Exception=>e
        @@report.step("#{e}")
        @@report.step("Expected Account Name: #{name}")
        @@report.step("Actual Account Name: " + @client.find_element(:id,"myIgnNicknameLabel").text)
        @@report.suite_end()
  		end
  	end
  	
  	def package_name(name)
      @@report.step("Does package name match?")
  		begin
  			if @client.find_element(:id,"packageNameLabel").text.include? name
  				puts "Yes!"
  				return true
  			else
  				raise "Package name does not match!"
  			end
  		rescue Exception=>e
        @@report.step("#{e}")
        @@report.step("Expected Package Name: #{name}")
        @@report.step("Actual Package Name: " + @client.find_element(:id,"packageNameLabel").text + "</div>")
        @@report.suite_end()
  		end
  	end
  	
   	def package_price(price)
       @@report.step("Does package price match?")
  		begin
  			if @client.find_element(:id,"costLabel").text.include? price.to_s
          @@report.step("Yes!")
  				return true
  			else
  				raise "Package price does not match!</div>"
  			end
  		rescue Exception=>e
        @@report.step("#{e}")
        @@report.step("Expected Package Price: #{price} ")
        @@report.step("Actual Package Price: " + @client.find_element(:id,"costLabel").text)
        @@report.suite_end()
  		end
  	end

end