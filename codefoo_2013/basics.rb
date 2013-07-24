# this is a comment

class CodeFoo # class definition
  
  @year # instance variable
  
  def awsomeness # method definition
    awesome = 'so awesome' # local variable
    awesome # return value
  end # end method 
  
  def year # getter method
    @year 
  end
  
  def year=(year) # setter method
    @year = year
  end

end # end class

# NOTES
# No semi-colons needed. They're optional but style dictates they don't be used. 
# No keyword 'return'. It's optional and style dictates it be omitted unless needed.

code_foo = CodeFoo.new # instantiate the class and assign it
code_foo.year = '2013' # call year's setter method
puts code_foo.year # call the year's getter method and output it