require 'thread'
require 'rest_client'

while true
  Thread.new do
    RestClient.get "http://10.97.64.101:8081/wiki/v3/wikis"
    RestClient.get "http://10.97.64.101:8081/wiki/v3/wikis/50c2398b8b0aa31ea7000001"
  end
end