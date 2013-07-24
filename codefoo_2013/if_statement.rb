number = 1

# contrived example
if number == 1
  puts 'number is 1'
elsif number == 2 
  puts 'number is 2'
else
  puts 'number is nethier 1 nor 2'
end

# this does the same thing as above
puts 'number is 1' if number == 1
puts 'number is 2' if number == 2
puts 'number is nethier 1 nor 2' if number != 1 && number != 2

# more useful
def increment_whole_number(number)
  raise ArgumentError if number.class != Fixnum
  number + 1
end

puts increment_whole_number 1