require 'net/http'
require 'uri'
require 'rubygems'
require 'json'

#url = 'http://social-stg-services.ign.com/v1.0/social/rest/status/1938462/@self?st=1938462:1938462:0:ign.com:my.ign.com:0:0'
#params = {
#	'status' => 'testing status ruby!'
#}.to_json

#resp = Net::HTTP.new(url, initheader = {'Content-Type' =>'application/json'})

#resp.request_post(url, params, initheader = {'Content-Type' =>'application/json'})

#resp = Net::HTTP.post(url, params) 

#puts resp.body



uri = 'http://foolizanagi.com/'
response = Net::HTTP.get_response(URI.parse(uri))
	case response
    when Net::HTTPSuccess     then puts "OK"
    when Net::HTTPRedirection then puts "redirect"
    else
        response.error!
    end
	puts response.body