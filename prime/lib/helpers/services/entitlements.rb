require 'json'
require 'rest_client'
require 'rubygems'

class TopazEntitlements < Page
	def is_user_entitled(topaz_id)
		puts "Does user have entitlement?"
  	begin
  		if JSON.parse((RestClient.get "http://secure-stg.ign.com/entitlements/prime/#{topaz_id}").body)['titles']['Prime'].include? 'true'
  			puts "Yes!"
  			return true
  		else
  			raise "User is not entitled!"
  		end
  	rescue Exception=>e
  		puts e
  		puts "Expected Entitlement Setting true"
  		puts "Actual Entitlement Setting" + JSON.parse((RestClient.get "https://secure.ign.com/entitlements/prime/#{topaz_id}").body)
  	end
	end
end