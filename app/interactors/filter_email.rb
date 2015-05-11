class FilterEmail

	def initialize()

	end

	#Accepts a que with emails that's going to be categorized, and how many threads it should use
	def execute_filter_threads(email_queue, num_of_threads)
		lock = Mutex.new
        filter_threads = []
        #email = email_queue.pop 

        #puts email.subject
        #email = email_queue.pop 
        #puts email.subject


		num_of_threads.times do
			filter_threads << Thread.new do # Start the threads
				n = 0
				puts "\nSTART TRHEAD: ", Thread.current.object_id ," \n"
				continue = true
				=begin
				while continue == true
					temp_email = nil
					n+=1
					print "at start of while loop: ", n, "\n"
					
					print "que empty? ", email_queue.empty?, "\n"
					temp_email = email_queue.pop
					#if !email_queue.empty?
						print "not empty \n"
						#temp_email = lock.synchronize{
							#email_queue.pop
						#}
					#	temp_email = email_queue.pop
					#else
					#	print "temp_email is empty", n, "\n"
					#	continue = false

					#end
					#if !email_queue.empty?
					#	lock.synchronize{
					#		temp_email = email_queue.pop
					#	}
					#end
					print "temp_email.subject: ", temp_email.subject, " \n"
					print "klar sync", n, "\n"
					#puts "temp_email.subject: ". temp_email.subject
					#if temp_email != nil
					if temp_email != nil
						print "Filtering email..", n, "\n"
						FilterEmail.new.filter_mail(temp_email)
						print "done filtering email.", n, "\n"
					else
						print "temp_email is empty", n, "\n"
						continue = false

					end
					print "at end of while loop ", n, "\n"
				end
				

				while !email_queue.empty?
						temp_email = nil
						n+=1
						print "at start of while loop: ", n, "\n"

						temp_email = lock.synchronize{
							email_queue.pop
						}


				end
				=end
				puts "outside while loop"

			end
		end
		puts "at end. Joining threads"
		#filter_threads.each do |x_thread|
		#	puts "hello"
		#	x_thread.join
		#end
		puts "at end. Joined threads"
		sleep(10)
		puts "Exiting"
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
    #puts "\n START find_category\n"
		#Check each category's email address to see if it fits:
		unless check_email_addresses(email)
			#Second check each word in subject and body against keywords in categories
			check_subject_and_body(email)
		end
	end

	#Checks the email address in the email against the email addresses in each category
	def check_email_addresses(email)
        Category.all.each do |cat|

			accounts = cat.email_accounts
            #accounts.find_each(:conditions => "email_address.eql? email.to.downcase") do
            #    attach_case_to_category(email,cat)
            #    return true
            #end

			accounts.each do |to|
				if to.email_address.downcase.eql? email.to.downcase
					attach_case_to_category(email, cat)
					return true
				end
			end
		end
		return false
	end



	#Checks each word against keywords in categories
	def check_subject_and_body(email)
		#Used to settle which word to use.
		#puts "\n\n\ncheck_subject_and_body\n\n\n"
		temp_points = 0 #The score for the current category
		points = 0 # The highest score achived


		# DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!
		#Seperate the words in the subject
		#These will need to be improved since they don't work properly with swedish charaters
		subject_words = email.subject.scan(/\w+/)
		#puts "Subject words: "
		#subject_words.each do |sub|
		#	puts sub
		#end
		#puts "Body words: "

		body_words = email.body.scan(/\w+/)
		#body_words.each do |bod|
		#	puts bod
		#end


		# DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!

		Category.all.each do |cat|
			#puts "Cat name: ", cat.name
			#Checks each word in subject and body against keywords in categories
			temp_points += check_words(cat.key_words, subject_words, true)
			#print "Subject temp_points: ", temp_points ,"\n"
			#BODY
			temp_points += check_words(cat.key_words, body_words)
			#print "Body temp_points: ", temp_points ,"\n"
			if temp_points > points
                #puts "found something, attaching cat"
				points = temp_points
				attach_case_to_category(email, cat)
                #puts "Attached: ", email.category.name
			end
			temp_points = 0
		end
	end

    def attach_case_to_category(email, cat)
        #email should always have a case attached to it
        #temp_Case = email.case

        temp_case = email.case
        cat.cases << temp_case
        cat.save

        email.case = temp_case
        email.case.active = true

        email.category = cat
        email.save
    end

	#check each word in either subject or body against the keywords in each category's key_words
	def check_words(key_words, words, is_subject = false)
		temp_points = 0
		words.each do |word|
			temp_points += check_key_words(word, key_words, is_subject)
		end
		return temp_points
	end

	#check each word against each keyword
	def check_key_words(word, key_words, is_subject = false)
		temp_points = 0
		key_words.each do |key|
			if key.word.downcase.eql? word.downcase
				if is_subject
					#if found in subject score * 2
					temp_points += key.point * 2
				else
					temp_points += key.point
				end

			end
		end
		return temp_points
	end

end