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



#

		filter_all_emails
		#filter_all_caseless_emails
		# Join the new thread

		#-------------------------------
		redirect_to filter_mail_index_path

		#filter_all_caseless_emails
		
		
	end

	def filter_all_caseless_emails
		require 'thread'
		@debug = true
		@NUM_OF_THREADS = 4 # How many threads to executed concurrently
		#Saves the tasks in a que to regulate num of threads
		queue = Queue.new

		Email.all.each do |email| # Go through all emails and check if theres no case attached
			#if email.category.blank? #or email.case.blank?
			if email.case.blank?
				queue.push(email) 
			end
		end

		#Start executing the threads
		#FilterEmail.new.execute_filter_threads(queue, @NUM_OF_THREADS)
		return true
	end	
	
	
	def filter_all_emails
		require 'thread'
		
		@debug = true
		@NUM_OF_THREADS = 4 # How many threads to executed concurrently
		#Saves the tasks in a que to regulate num of threads
		queue = Queue.new

		Email.all.each do |email| # Go through all emails and check if theres no case attached
			queue.push(email) 
			#FilterEmail.new.filter_mail(email)
		end

		#Start executing the threads
		FilterEmail.new.execute_filter_threads(queue, @NUM_OF_THREADS)
		return true
	end	
	
	



end
#end