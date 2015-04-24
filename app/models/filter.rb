#Adds a category to the mail by guessing which one it belongs to
class Filter
  require_relative 'mail'
  require_relative 'category'

  
  def initialize(name)
    #check name
    if not name.is_a? String
      print "Not a string"
      return false
    end  
    @filter_name = name
    @categories = Array.new
    @debug = false
    return true
  end
  

  def get_name
    return @filter_name
  end
  
  def filter_mail(mail)
    #check that its a mail
    if not mail.is_a? Mail
      puts "not an mail object"
      return false
    end
    
    #@mailToFilter = mail 

    
    # first check subject line and add points

    
    checkPoints(@categories, mail)
    
    return true
    
  end
  
  #Checks mail-to addreses against a mail object
  def check_to_address(categories, mail)
    i_limit = categories.length
    i = 0
    #fetch the toMail addresses from each category and compare it to the mails to mail address
    until i > i_limit -1 do
      #print mail.get_mail_to_address , " <---- HaR \n"
      if compare_to_addresses(categories.fetch(i).get_to_mail_address_array(),mail.get_mail_to_address) 
        # if it returns true then set category and stop looking and skip word check
        if @debug then print " Match found!!!!!!!!!!!!!!!!!!! ----------------!!!!!!!!!!!! \n" end
        mail.set_category(categories.fetch(i))
        return true
      end
      i+=1
      
    end
  end
  
  #Compares and array with words against a word and 
  def compare_to_addresses(array,word)
    i_limit = array.length
    i=0
    
    until i > i_limit -1 do
      #if @subject_array.fetch(j).downcase.eql? @categories.fetch(i).get_key_word(k).get_word
      if array.fetch(i).downcase.eql? word
        #return true if match found
        if @debug then print "Mail address match found!!! ______________\n" end

        return true
      end
      
    end
    
    #if nothing found then return false so it continues to word filtering
    return false
    
  end
  
  #def checkBodyAndSubjectAgainstEachCategory(category, mail)
  #    i_limit = categories.length
  #    i = 0;
  #    
  #end
  
  #Splits up and string of words and checks them against categories 
  #and sets a category to the category that got the most points
  def checkPoints(categories, mail)
    subject_to_check = mail.get_subject
    body_to_check = mail.get_body
    
    #first word in a string
    subject_array = Array.new
    subject_array = split_string(subject_to_check)
    
    body_array = Array.new
    body_array = split_string(body_to_check)
   
    
    points = 0
    #check subject against filters
  
  
    #First check the to mail address against each filter:
    # If false is returned continue with word to word check:
    if not check_to_address(categories,mail)

      i_limit = categories.length
      i = 0;
      
      #takes max of two limits
      j_limit = max(subject_array.length,body_array.length)
      j=0
      
      #Loop checks each category
      until i > i_limit -1 do
        #checkBodyAndSubjectAgainstEachCategory(@categories.fetch(i), mail)
        #Print debug information
        if @debug then print "Using filter: ", @categories.fetch(i).get_name, " \n"  end
          
        #Adds the points and if higher than points sets that as category
        temp_points = 0 # reset temp_points
        if @debug then print "temp_points: ", temp_points, " \n" end
          
        #----
        #second loop checks each word in subject and body against keywords
        until j > j_limit -1 do
           k_limit = @categories.fetch(i).get_num_key_words
           k=0
           #third loop checks Subject against each keyword
           until k > k_limit -1 do
               #
               #first check if J is out of bounds
               if j < subject_array.length
                 #If not out of bounds compare the subject against the keyword
                 if subject_array.fetch(j).downcase.eql? @categories.fetch(i).get_key_word(k).get_word
                   
                    if @debug then print "Subject fit!!!!\n word: ", subject_array.fetch(j) , " fit \n" end
                    #Add to temp_points, if in subject then * 2
                    temp_points += @categories.fetch(j).get_key_word(k).get_point * 2
                    
                 end
               end
               #check words in body
               if j < body_array.length 
                #If not out of bounds compare the subject against the keyword
                if body_array.fetch(j).downcase.eql? @categories.fetch(i).get_key_word(k).get_word
                  if @debug then print "Body fit!!!!\n word: ", body_array.fetch(j).downcase ," fit\n"  end
                    #Add to temp_points, if in body then +
                   temp_points += @categories.fetch(i).get_key_word(k).get_point
                  end
                end
                 k+=1
             end # end k loop
      
             j += 1
        end # end j loop
        
        #checks if temp_points is bigger and if so then sets that as current category
        if points < temp_points
          #print "points: ", points , " tempPoinst: ", temp_points , "\n" 
          points = temp_points
          mail.set_category(@categories.fetch(i))
          if @debug then print "Setting mail to category: ", mail.get_category.get_name , "\n"  end
        end
         
         i += 1
         j=0
    end # end i loop
    if @debug then print "points: ", points;  end
  
   end # end true/false
   return points
  end
  
  
  
  #returns the max value out of two
  def max(a, b)
    if a > b
      return a
    end
    
    return b
  end
  
  def split_string(string)
     temp_array = Array.new
     #temp_array = string.split /\s ||
     temp_array = string.scan(/\w+/)
     #@body_to_check.split(' ','.','?','!')
     return temp_array
  end
  
  
  
  def add_category(category)
    #check that it is a category
    if not category.is_a? Category
      puts "not a category"
      exit
      return false
    end
    
   @categories.push(category)
    
   return true
    
  end
  
  def get_category(index)
    return @categories.fetch(index)
  end
    
end
  