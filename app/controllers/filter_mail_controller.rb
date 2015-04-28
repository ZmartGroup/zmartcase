class FilterMailController < ApplicationController

  @debug = true


  def index
  	
  	@emails = Email.all
  end

  def start_filtering

    Email.all.each do |email|
      if email.category.blank?
        find_category(email)
      end
    end


    #-------------------------------
  	redirect_to filter_mail_index_path
  end

  #Starts the proccess to find a category for an email
  def find_category(email)

    #FIRST CHECK IF THERE*S ALREADY A CASE!!!!!
    #checkCase() # DOES NOTHING ATM!!!!



    #Second  check each category's email address to see if it fits:
   unless checkEmailAddresses(email)
      #Second check each word in subject and body against keywords in categories
      checkSubjectAndBody(email)
    end 
  end


  # DOES NOTHING ATM!!!!
  #Checks if theres a prior case to add email to. Otherwise creates a new case
  def checkCase(email)
    
    #Add case ID to email Header if no prior case


    
  end
  
  #Checks the email address in the email against the email addresses in each category
  def checkEmailAddresses(email)

    #cats = Category.all

    Category.all.each do |cat|

      accounts = cat.email_accounts

      accounts.each do |to|
        if to.email_address.downcase.eql? email.to.downcase

          if @debug
            logger.debug "\n\n\n\n\n\n FOUND matching email address: \n"
            logger.debug "\nEmail Subject: "
            logger.debug email.subject
            logger.debug "\n Category: "
            logger.debug cat.id
            logger.debug "\n"
            logger.debug "\nDEBUG WORD:\n"
            logger.debug word
            logger.debug "\n Email Category: "
            logger.debug email.category_id
            logger.debug "\n\n\n"
          end

          email.category = cat
          email.save
          return true
        end
      end
    end
    return false
  end


  #Checks each word against keywords in categories
  def checkSubjectAndBody(email)
    #Used to settle which word to use. 
    tempPoints = 0 #The score for the current category
    points = 0 # The highest score achived 
    if @debug 
      logger.debug "\n\n Starting with mail from: "
      logger.debug email.from
      logger.debug "\n"
    end

    #Seperate the words in the subject
    #These will need to be improved since they don't work properly with swedish charaters
    subject_words = email.subject.scan(/\w+/)
    body_words = email.body.scan(/\w+/)


    #logger.debug email.subject

    #CATEGORY
    Category.all.each do |cat|

      #Checks each word in subject and body against keywords in categories
      tempPoints += checkWords(email, cat, subject_words, is_subject = true)

      #BODY
      tempPoints += checkWords(email, cat, body_words, is_subject = false)


      if tempPoints > points
        points = tempPoints
        logger.debug "\n\n\n Category set!!!! \n\n\n"
        #set cat
        email.category = cat
        email.save
      end
      tempPoints = 0
    end # end category

    # if no points found

    #if debug logger.debug "\nENDING!!!!! \n\n\n"

  end

  #check each word against each keyword
  def checkKeyWords(email, cat, word, key_words, is_subject = false)
    tempPoints = 0
    key_words.each do |key|
      #logger.debug key.word
      if key.word.downcase.eql? word.downcase
        if @debug
          logger.debug "\n\n\n FOUND a match for word: \n\n\n"
          logger.debug word
          logger.debug " against: "
          logger.debug key.word
          logger.debug "\n\n\n"
        end


        if is_subject
          #if found in subject score * 2
          tempPoints += key.point * 2
        else
          tempPoints += key.point
        end

      end
    end
    return tempPoints
  end

  

  #check each word in the SUBJECT against the keywords in each category's key_words
  def checkWords(email, cat, words, is_subject = false)
    tempPoints = 0
    words.each do |word|

      tempPoints += checkKeyWords(email, cat, word, cat.key_words, is_subject)
      #check each word against each keyword

    end 
    return tempPoints
  end

end
#end