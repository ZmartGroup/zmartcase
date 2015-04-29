class FilterMailController < ApplicationController

	@debug = true
  @HASHTAGNAME = "hashtagCaseID = "

	def index
		@emails = Email.all
	end

	#Filters all mails that has no category or case assigned to it
	#def filter_all_uncategorized_emails
	def start_filtering
		@debug = true

		logger.debug "\n\n\n\n\n\n START Filtering: "
		Email.all.each do |email|
			if email.category.blank? #or email.case.blank?
				if @debug
					logger.debug "\nFiltering mail with from: "
					logger.debug email.from
					logger.debug "\n"
				end
				filter_mail(email)
			end
		end

		logger.debug "\n END Filtering\n\n\n\n\n"
		#-------------------------------
		redirect_to filter_mail_index_path
	end

	#finds a case for the email or if non is found creates a new one and categorises it
	def filter_mail(email)
		logger.debug "\n START filter_mail\n"
		unless checkCase(email) #FIRST CHECK IF THERE'S ALREADY A CASE!!!!!
			create_new_case(email) # create new case if no case is present
			find_category(email) #and finally place that case in a category
		end
	end



	#SHOULD NOT BEEEE HEEEEREEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	def create_new_case(email)
		new_case = Case.new
		#tempHash = ('a'..'z').to_a.shuffle[0,64].join
		
		#new_case.hashtag = tempHash
		new_case.active = true
		new_case.save

		email.case = new_case
		email.save

		
	end



	#Starts the proccess to find a category for an email
	def find_category(email)
    logger.debug "\n START find_category\n"
		#Check each category's email address to see if it fits:
		unless checkEmailAddresses(email)
			#Second check each word in subject and body against keywords in categories
			checkSubjectAndBody(email)
		end 
	end


	#Checks if theres a prior case to add email to. Otherwise returns false
	def checkCase(email)
    if email.case_id.blank?
      return false
    else 
      #add email to case and return true
		  return true
    end
	end


	#Checks the email address in the email against the email addresses in each category
	def checkEmailAddresses(email)
		logger.debug "\n START checkEmailAddresses\n"
		Category.all.each do |cat|
			accounts = cat.email_accounts
			accounts.each do |to|
				if to.email_address.downcase.eql? email.to.downcase

					if @debug
						logger.debug "\n FOUND matching email address: \n"
						logger.debug "\nEmail Subject: "
						logger.debug email.subject
						logger.debug "\n Category: "
						logger.debug cat.id
						logger.debug "\n"
						logger.debug "\nDEBUG WORD:\n"
						logger.debug word
						logger.debug "\n Email Category: "
						logger.debug email.category_id
						logger.debug "\n"
					end

					email.category = cat
          email.case.category = cat
					email.save
					return true
				end
			end
		end
		logger.debug "\n END checkEmailAddresses. Returning false\n"
		return false
	end


	#Checks each word against keywords in categories
	def checkSubjectAndBody(email)
		logger.debug "\n START checkSubjectAndBody\n"
		#Used to settle which word to use. 
		tempPoints = 0 #The score for the current category
		points = 0 # The highest score achived 
		if @debug 
			logger.debug "\n\n checkSubjectAndBody with mail from: "
			logger.debug email.from
			logger.debug "\n"
		end

		#Seperate the words in the subject
		#These will need to be improved since they don't work properly with swedish charaters
		subject_words = email.subject.scan(/\w+/)
		body_words = email.body.scan(/\w+/)

		Category.all.each do |cat|

			#Checks each word in subject and body against keywords in categories
			tempPoints += checkWords(email, cat, subject_words, is_subject = true)

			#BODY
			tempPoints += checkWords(email, cat, body_words, is_subject = false)


			if tempPoints > points
				points = tempPoints
				logger.debug "\n\n\n Category set!!!! \n\n\n"
				#set cat % case
          email.category = cat
          email.case.category = cat
          email.save
			end
			tempPoints = 0
		end # end category

		# if no points found

		#if debug logger.debug "\nENDING!!!!! \n\n\n"
		logger.debug "\n END checkSubjectAndBody\n"
	end

	#check each word against each keyword
	def checkKeyWords(email, cat, word, key_words, is_subject = false)
		tempPoints = 0
		key_words.each do |key|
			if false
				logger.debug "Checking word: "
				logger.debug word
				logger.debug " against: "
				logger.debug key.word
				logger.debug "\n"
			end
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