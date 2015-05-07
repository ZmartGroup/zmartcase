class FilterMailController < ApplicationController
	#coding: UTF-8

	def index
		@emails = Email.all
		#generate_random_emails(10)
		#remove_all_cases_and_categories_from_emails
		@categories = Category.all
	end


	#Filters all mails that has no category or case assigned to it
	#This will not be used when in production
	def start_filtering
		require 'thread'
		@debug = true
		@NUM_OF_THREADS = 4 # How many threads to executed concurrently

		#Saves the tasks in a que to regulate num of threads
		queue = Queue.new

		logger.debug "\n\n\n\nSTART Filtering: "

		Email.all.each do |email| # Go through all emails and check if theres no case attached
			#if email.category.blank? #or email.case.blank?
			if true #email.case.blank?
				if false #@debug
					Rails.logger.debug "\nFiltering mail with from: "
					Rails.logger.debug email.from
					Rails.logger.debug "\n"
				end
				queue.push(email) 
				#FilterEmail.new.filter_mail(email)
			end
		end
#

		#Rails.logger.debug "\n\n\n QUE made, returning to index...\n\n"
		
		#Create new thread
	 	#FilterEmail.new.filter_mail(Email.last)

		

		#Start executing the threads
		FilterEmail.new.execute_filter_threads(queue, @NUM_OF_THREADS)

		# Join the new thread
		Rails.logger.debug "\n\n\n\n\n All threads done!!!!!!!!!!!!!!\n\n\n\n\n"

		Rails.logger.debug "\n END Filtering\n\n\n\n\n"
		#-------------------------------
		redirect_to filter_mail_index_path
		
	end











end
#end