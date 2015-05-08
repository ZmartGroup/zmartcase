class FilterEmail

	def initialize()

	end

	#Accepts a que with emails that's going to be categorized, and how many threads it should use
	def execute_filter_threads(queue, num_of_threads)
		lock = Mutex.new
		
		num_of_threads.times do
			Thread.new do # Start the threads
				puts "START TRHEAD: ", Thread.current.object_id ," \n"
				continue = true
				while continue == true
					
					tempMail = lock.synchronize{
						queue.pop
					}

					if tempMail
						FilterEmail.new.filter_mail(tempMail)
					else
						continue = false
					end	
				end
				ActiveRecord::Base.connection.close
				puts "\n\n\nEND TRHEAD: ", Thread.current.object_id ," \n\n\n\n"
			end
		end
	end

	#finds a case for the email or if non is found creates a new one and categorises it
	def filter_mail(email)

		#unless check_case(email) #FIRST CHECK IF THERE'S ALREADY A CASE!!!!!
			find_category(email) #and finally place that case in a category
		#end
	end

	#Checks if theres a prior case to add email to. Otherwise returns false
	def check_case(email)
	    if email.case_id.blank?
	      	return false
	    else 
			return true
	    end
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
		Category.all.each do |cat|
			accounts = cat.email_accounts
			accounts.each do |to|
				if to.email_address.downcase.eql? email.to.downcase
					create_new_case_and_attach(email, cat)
					return true
				end
			end
		end
		return false
	end

	def create_new_case_and_attach(email, cat)
		if email.case.blank?
        	temp_Case = Case.new
		else
			temp_Case = email.case
		end

		cat.cases << temp_Case
       	cat.save

        email.case = temp_Case
		email.case.active = true

		email.category = cat
		email.save
	end

	def check_if_category_has_case(cat, a_case)
		cat.cases.each do |b_case|
			if b_case.equal? a_case
				return true
			end
		end
		return false
	end

	#Checks each word against keywords in categories
	def checkSubjectAndBody(email)
		#Used to settle which word to use. 

		tempPoints = 0 #The score for the current category
		points = 0 # The highest score achived 

		
		# DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!
		#Seperate the words in the subject
		#These will need to be improved since they don't work properly with swedish charaters
		subject_words = email.subject.scan(/\w+/)
		body_words = email.body.scan(/\w+/)
		# DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!

		Category.all.each do |cat|
			#Checks each word in subject and body against keywords in categories
			tempPoints += checkWords(cat.key_words, subject_words, true)
			#BODY
			tempPoints += checkWords(cat.key_words, body_words)

			if tempPoints > points
				points = tempPoints
				create_new_case_and_attach(email, cat)
			end
			tempPoints = 0
		end 
	end

	#check each word in either subject or body against the keywords in each category's key_words
	def checkWords(key_words, words, is_subject = false)
		tempPoints = 0
		words.each do |word|
			tempPoints += checkKeyWords(word, key_words, is_subject)
		end 
		return tempPoints
	end

	#check each word against each keyword
	def checkKeyWords(word, key_words, is_subject = false)
		tempPoints = 0
		key_words.each do |key|
			if key.word.downcase.eql? word.downcase
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