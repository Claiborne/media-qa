require 'thread'
require 'net/http'
require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'
require 'assert'

while true
  Thread.new do
    RestClient.get "http://10.97.64.101:8080/redirect/v3/redirects?from=http://xbox360.ign.com"
  end
  Thread.new do
    RestClient.get "http://10.97.64.101:8080/redirect/v3/redirects?from=http://pc.ign.com"
  end
end