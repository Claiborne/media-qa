##################################################
#
# This is the helper file for the /prime-payment page
#
###################################################

class PrimeManage < Page

	def visit(baseurl)
		@client.get "http://#{baseurl}/prime-manage"
	end
  
	def get_last_four
		puts @client.find_element(:xpath, "//div[@class='mgmt-panel prime-manage']/table/tbody/tr[4]/td/p").text
	end
end
