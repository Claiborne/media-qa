#require 'tiny_tds'

module SqlServer    
  def get_user_id
    #creates a new db object using our dev sql server
    # client = TinyTds::Client.new(:username => 'fklun', :password => 'J3d1r0xorz%', :host => 'igndevsql01.las1.colo.ignops.com', :database => 'Gametrack', :login_timeout => 60)
     # puts client.active?
    # #opens the Gametrack DB which contains all the user information
    # db.open('Gametrack')
    # #queries the database and extracts the userID from a given email address
    # user_id = db.query("SELECT userid from users WHERE email ='#{user_email}';")
    # puts "user email is #{user_email}"
    # puts "userid is #{user_id}"
    # user_id.to_s
    # #user_id = user_id.match(/\[\[(.*)\]\]/)  
    # puts user_id
#     
    # #puts "userid is #{user_id}"
    # #close the database connection and returns the userID
    # db.close
    #return user_id
  end  
end