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
					logger.debug "\n\n\n\n\n\nFiltering mail with from: "
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
		#FIRST CHECK IF THERE'S ALREADY A CASE!!!!!
		unless checkCase(email) # DOES NOTHING ATM!!!!
			create_new_case(email)
			find_category(email)
		end
	end



	#SHOULD NOT BEEEE HEEEEREEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	def create_new_case(email)
		new_case = Case.new
		tempHash = ('a'..'z').to_a.shuffle[0,64].join
		
		new_case.hashtag = tempHash

		new_case.active = true
		new_case.save

		email.case = new_case
		email.save
		#add hash to email body
		if @debug
				logger.debug "\n\n\nCreated new Case\n"
				logger.debug "Case hashtag: "
				logger.debug email.case.hashtag
				logger.debug "\n"
		end
		add_hash_to_email_body(email, new_case.hashtag)
		
	end

	#SHOULD NOT BEEEE HEEEEREEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	#ATM just adds the hash to the begning of the mail
	def add_hash_to_email_body(email, hashtag)

		#email.body = email.body.insert(0, "TESTSTSTESXTT  TEST\n")

		#email.body += "."
		#email.body = email.body[0...-1]

		#logger.debug "------------------------------" + email.body
    #logger.debug "------------------------------" + email.changes.inspect
		#email.save!

		#email.create()
		##.insert(0, "hashtagID =START: ", hashtag ," END")
	end

	#def find_index_for_hash_id(email)
	#	email
	#end


	#Starts the proccess to find a category for an email
	def find_category(email)
		#Check each category's email address to see if it fits:
		unless checkEmailAddresses(email)
			#Second check each word in subject and body against keywords in categories
			checkSubjectAndBody(email)
		end 
	end


	# DOES NOTHING ATM!!!!
	#Checks if theres a prior case to add email to. Otherwise creates a new case
	def checkCase(email)
    #seperate the words
    body_words = email.body.scan(/\w+/)

		#scans body for hashtagID
    body_words.each do |word|
      if @HASHTAGNAME.eql? word.downcase
        #tries to match it with a case
        logger.debug "\nMATCH!!!!!!!!!!!!!\n"
      end
    end

		return false
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
		logger.debug "\n END checkSubjectAndBody\n"
	end

	#check each word against each keyword
	def checkKeyWords(email, cat, word, key_words, is_subject = false)
		
			#logger.debug "\n START checkKeyWords:\n"


		tempPoints = 0
		key_words.each do |key|
			if false
				#logger.debug key.word
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
		#logger.debug "\n END checkKeyWords\n"
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