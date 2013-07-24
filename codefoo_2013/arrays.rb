good_guys = ['Solid Snake', 'Chris Redfield', 'Ken Masters']

# length and count
good_guys.length #=> 3
good_guys.count #=> 3

# acessing elements
good_guys[0] #=> 'Solid Snake'
good_guys.last #=> 'Ken Masters'

# adding elements
good_guys << 'Commander Shepard'
good_guys #=> ['Solid Snake', 'Chris Redfield', 'Ken Masters', 'Commander Shepard']

# concatenation
good_guys + ['Yoshi','Mega Man']

# remove duplicates
items = ['bullets', 'bullets', 'green herb', 'hex key']
items.uniq #=> ['bullets', 'green herb', 'hex key'] 

# comparison
[ 1, 1, 3, 5 ] & [ 1, 1, 2, 3 ] #=> [ 1, 3 ] common/shared elements w/o duplocates
[1, 2, 3, 4, 5] - [1, 2, 5] #=> [3, 4]
[1, 2, 3].include? 1 #=> true

# sorting
letters = [ "d", "a", "e", "c", "b"]
letters.sort  #=> ["a", "b", "c", "d", "e"]

# deleting elements
good_guys.delete 'Ken Masters' #=> 'Ken Masters'
good_guys #=> ['Solid Snake', 'Chris Redfield']

# interation
good_guys.each do |guy|
  puts guy   
end

# array shortcut
%w(snake redfield masters) #=> ['snake', 'redfield', 'masters']