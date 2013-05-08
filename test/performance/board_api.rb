require 'thread'
require 'rest_client'

while true
  Thread.new do
    RestClient.get "http://10.97.64.101:8082/board/v3/boards"
  end
end