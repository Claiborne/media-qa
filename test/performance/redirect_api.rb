require 'thread'
require 'rest_client'

while true
  Thread.new do
    RestClient.get "http://10.97.64.101:8080/redirect/v3/redirects?from=http://xbox360.ign.com"
  end
end