class FilterEmail

	def initialize()

	end
	#finds a case for the email or if non is found creates a new one and categorises it
	def filter_mail(email)
		Rails.logger.debug "\n START filter_mail\n Thread ID: "
		Rails.logger.debug Thread.current.object_id
		Rails.logger.debug "\n"

		unless check_case(email) #FIRST CHECK IF THERE'S ALREADY A CASE!!!!!
			
			create_new_case(email) # create new case if no case is present
			find_category(email) #and finally place that case in a category
		end
		#find_category(email) # if we want to try filtering even if the mail has a case
	end


	#Checks if theres a prior case to add email to. Otherwise returns false
	def check_case(email)
	    if email.case_id.blank?
	      	return false
	    else 
			return true
	    end
	end


	#SHOULD NOT BEEEE HEEEEREEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	def create_new_case(email)
		new_case = Case.new
		new_case.active = true
		new_case.save
		#Attach case to email
		email.case = new_case
		email.save
	end



	#Starts the proccess to find a category for an email
	def find_category(email)
    Rails.logger.debug "\n START find_category\n"
		#Check each category's email address to see if it fits:
		unless checkEmailAddresses(email)
			#Second check each word in subject and body against keywords in categories
			checkSubjectAndBody(email)
		end 
	end





	#Checks the email address in the email against the email addresses in each category
	def checkEmailAddresses(email)
		Rails.logger.debug "\n START checkEmailAddresses\n"
		Category.all.each do |cat|
			accounts = cat.email_accounts
			accounts.each do |to|
				if to.email_address.downcase.eql? email.to.downcase

					if @debug
						Rails.logger.debug "\n FOUND matching email address: \n"
						Rails.logger.debug "\nEmail Subject: "
						Rails.logger.debug email.subject
						Rails.logger.debug "\n Category: "
						Rails.logger.debug cat.id
						Rails.logger.debug "\n"
						Rails.logger.debug "\nDEBUG WORD:\n"
						Rails.logger.debug word
						Rails.logger.debug "\n Email Category: "
						Rails.logger.debug email.category_id
						Rails.logger.debug "\n"
					end

					email.category = cat
          			email.case.category = cat
					email.save
					return true
				end
			end
		end
		Rails.logger.debug "\n END checkEmailAddresses. Returning false\n"
		return false
	end


	#Checks each word against keywords in categories
	def checkSubjectAndBody(email)
		#CODING: UTF-8
		Rails.logger.debug "\n START checkSubjectAndBody\n"
		#Used to settle which word to use. 
		tempPoints = 0 #The score for the current category
		points = 0 # The highest score achived 
		if @debug 
			Rails.logger.debug "\n\n checkSubjectAndBody with mail from: "
			Rails.logger.debug email.from
			Rails.logger.debug "\n"
		end

		# DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!

		#Seperate the words in the subject
		#These will need to be improved since they don't work properly with swedish charaters
		subject_words = email.subject.scan(/\w+/)
		body_words = email.body.scan(/\w+/)
		# DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!



		Category.all.each do |cat|

			#Checks each word in subject and body against keywords in categories
			tempPoints += checkWords(email, cat, subject_words, is_subject = true)
			#BODY
			tempPoints += checkWords(email, cat, body_words, is_subject = false)

			if tempPoints > points
				points = tempPoints
				Rails.logger.debug "\n\n\n Category set!!!! \n\n\n"
				#set cat % case
          		email.category = cat
          		email.case.category = cat
          		email.save
			end
			tempPoints = 0
		end # end category


		#if debug logger.debug "\nENDING!!!!! \n\n\n"
		Rails.logger.debug "\n END checkSubjectAndBody\n"
	end

		#check each word in either subject or body against the keywords in each category's key_words
	def checkWords(email, cat, words, is_subject = false)
		tempPoints = 0
		words.each do |word|

			tempPoints += checkKeyWords(email, cat, word, cat.key_words, is_subject)
			#check each word against each keyword

		end 
		return tempPoints
	end

	#check each word against each keyword
	def checkKeyWords(email, cat, word, key_words, is_subject = false)
		tempPoints = 0
		Rails.logger.debug "\nSTART CHECK KEYWORDS\n"
		key_words.each do |key|
			#if true #@debug
				Rails.logger.debug "Checking word: "
				Rails.logger.debug word
				Rails.logger.debug " against: "
				Rails.logger.debug key.word
				Rails.logger.debug "\n"
			#endRails.wncase.eql? word.downcase
			if key.word.downcase.eql? word.downcase
				if @debug
					Rails.logger.debug "\nFOUND a match for word: \n"
					Rails.logger.debug word
					Rails.logger.debug " against: "
					Rails.logger.debug key.word
					Rails.logger.debug "\n"
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

	# => FILTER MAIL 

	#finds a case for the email or if non is found creates a new one and categorises it
	def filter_mail(email)
		Rails.logger.debug "\n START filter_mail\n Thread ID: "
		Rails.logger.debug Thread.current.object_id
		Rails.logger.debug "\n"

		unless check_case(email) #FIRST CHECK IF THERE'S ALREADY A CASE!!!!!
			
			create_new_case(email) # create new case if no case is present
			find_category(email) #and finally place that case in a category
		end
		#find_category(email) # if we want to try filtering even if the mail has a case
	end



	#SHOULD NOT BEEEE HEEEEREEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	def create_new_case(email)
		new_case = Case.new
		new_case.active = true
		new_case.save
		#Attach case to email
		email.case = new_case
		email.save
	end



	#Starts the proccess to find a category for an email
	def find_category(email)
    Rails.logger.debug "\n START find_category\n"
		#Check each category's email address to see if it fits:
		unless checkEmailAddresses(email)
			#Second check each word in subject and body against keywords in categories
			checkSubjectAndBody(email)
		end 
	end


	#Checks if theres a prior case to add email to. Otherwise returns false
	def check_case(email)
	    if email.case_id.blank?
	      return false
	    else 
			return true
	    end
	end


	#Checks the email address in the email against the email addresses in each category
	def checkEmailAddresses(email)
		Rails.logger.debug "\n START checkEmailAddresses\n"
		Category.all.each do |cat|
			accounts = cat.email_accounts
			accounts.each do |to|
				if to.email_address.downcase.eql? email.to.downcase

					if @debug
						Rails.logger.debug "\n FOUND matching email address: \n"
						Rails.logger.debug "\nEmail Subject: "
						Rails.logger.debug email.subject
						Rails.logger.debug "\n Category: "
						Rails.logger.debug cat.id
						Rails.logger.debug "\n"
						Rails.logger.debug "\nDEBUG WORD:\n"
						Rails.logger.debug word
						Rails.logger.debug "\n Email Category: "
						Rails.logger.debug email.category_id
						Rails.logger.debug "\n"
					end

					email.category = cat
          			email.case.category = cat
					email.save
					return true
				end
			end
		end
		Rails.logger.debug "\n END checkEmailAddresses. Returning false\n"
		return false
	end


	#Checks each word against keywords in categories
	def checkSubjectAndBody(email)
		#CODING: UTF-8
		Rails.logger.debug "\n START checkSubjectAndBody\n"
		#Used to settle which word to use. 
		tempPoints = 0 #The score for the current category
		points = 0 # The highest score achived 
		if @debug 
			Rails.logger.debug "\n\n checkSubjectAndBody with mail from: "
			Rails.logger.debug email.from
			Rails.logger.debug "\n"
		end

		# DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!

		#Seperate the words in the subject
		#These will need to be improved since they don't work properly with swedish charaters
		subject_words = email.subject.scan(/\w+/)
		body_words = email.body.scan(/\w+/)
		# DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!



		Category.all.each do |cat|

			#Checks each word in subject and body against keywords in categories
			tempPoints += checkWords(cat, subject_words, is_subject = true)

			#BODY
			tempPoints += checkWords(cat, body_words, is_subject = false)

			if tempPoints > points
				points = tempPoints
				Rails.logger.debug "\n\n\n Category set!!!! \n\n\n"
				#set cat % case
          		email.category = cat
          		email.case.category = cat
          		email.save
			end
			tempPoints = 0
		end # end category


		#if debug logger.debug "\nENDING!!!!! \n\n\n"
		Rails.logger.debug "\n END checkSubjectAndBody\n"
	end

		#check each word in either subject or body against the keywords in each category's key_words
	def checkWords(cat, words, is_subject = false)
		tempPoints = 0
		words.each do |word|

			tempPoints += checkKeyWords(word, cat.key_words, is_subject)
			#check each word against each keyword

		end 
		return tempPoints
	end

	#check each word against each keyword
	def checkKeyWords(word, key_words, is_subject = false)
		tempPoints = 0
		Rails.logger.debug "\nSTART CHECK KEYWORDS\n"
		key_words.each do |key|
			if true #@debug
				Rails.logger.debug "Checking word: "
				Rails.logger.debug word
				Rails.logger.debug " against: "
				Rails.logger.debug key.word
				Rails.logger.debug "\n"
			end
			if key.word.downcase.eql? word.downcase
				if @debug
					Rails.logger.debug "\nFOUND a match for word: \n"
					Rails.logger.debug word
					Rails.logger.debug " against: "
					Rails.logger.debug key.word
					Rails.logger.debug "\n"
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




end