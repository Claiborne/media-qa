require 'colorize'

# basic, minimal ways to raise an exception
raise Exception
raise Exception, '***This is my custom exception message. It is optional***'
raise Exception.new '***This is my custom exception message. It is optional***'

# begin, rescue, end
# will catch StandardError exceptions and descendants (like Runtime)
begin
  puts undefined_variable
rescue => e 
  puts ">> This is the name of the exception being raised: "+"#{(e.class)}".green
  puts ">> This is the message of the exception being raised: "+"#{e.message}".green
  puts ">> This is the backtrace of the exception being raised: "+" #{e.backtrace}".green
end

# closer to the real world
begin 
  puts undefined_variable
rescue => e
  raise e, "Oh snap: a #{e.class} Exception was raised.".red
end

# ensure 
begin
  file = File.open("arrays.rb")
  raise Exception.new '***This is my custom exception message. It is optional***'
rescue
  puts "I am rescue code".yellow
ensure
  file.close
  puts 'File successfully closed'.green
end

  
