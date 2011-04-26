class XMLog 

    def open(filename)
          filename = "#{filename}_#{CustomTime.combined_time}.xml"
          xml_log = File.new(filename, a)
          return xml_log    
    end
    
    def close(filename)
        File.close(filename)
    end
    
end
