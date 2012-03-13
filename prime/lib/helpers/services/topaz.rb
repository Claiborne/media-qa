require 'json'
require 'rest_client'
require 'rubygems'

class Topaz < Page
	def get_topaz_id(username)
   	return JSON.parse((RestClient.get "http://social-stg-services.ign.com/v1.0/social/rest/people/nickname.#{username}/@self").body)['entry'][0]['accounts'][1]['key1']
	end
end