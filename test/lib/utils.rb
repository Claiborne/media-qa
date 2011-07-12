module Utils
 def self.run(command, verbose = false, message = nil)
   if verbose then
     puts "#{message}"
     puts command
     result = system("#{command}")
     puts "result: #{result}"
     return result
   else
    system("#{command}")
   end
  end
end
