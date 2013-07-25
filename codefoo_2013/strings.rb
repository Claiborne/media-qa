hello = 'hello' # a string
world = 'world'
hello_world = hello + ' ' + world # string concatenation
hello_world #=> hello world

# upper case everything
hello_world.upcase #=> HELLO WORLD

# using regular expressions
hello_world.match /o world/ #=> o world

# change to an integer
one = '1'.to_i
one.class #=> Fixnum

# string comparison 
'soup' == 'soup' #=> true

# checking for contents
'hello'.empty? #=> false
''.empty? #=> true

# remove leading and trailing white space
hi = "      hi       "
hi.length #=> 15
hi = hi.strip
hi.length #=> 2

# string substitution
'hello world'.gsub(/hello/,'hi') #=> hi world

# getting input from console
puts "Would you like to play again? (y/n)"
answer = gets().downcase.strip