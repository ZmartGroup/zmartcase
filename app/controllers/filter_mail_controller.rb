class FilterMailController < ApplicationController
	#coding: UTF-8

	def index
		@emails = Email.all
		@categories = Category.all
	end


	#Filters all mails that has no category assigned to it
	def start_filtering
		filter_all_emails

		redirect_to filter_mail_index_path

	end

	def filter_all_caseless_emails
		require 'thread'
		@debug = true
		@NUM_OF_THREADS = 4 # How many threads to executed concurrently
		#Saves the tasks in a que to regulate num of threads
		queue = Queue.new

		Email.all.each do |email| # Go through all emails and check if theres no case attached

			if  email.case.blank?
				email.case = Case.new
				queue.push(email)
			end

		end

		#Start executing the threads
		ThreadedFilterEmail.new.execute_filter_threads(queue, @NUM_OF_THREADS)
		return true
	end

	def filter_all_emails
		require 'thread'
		
		@NUM_OF_THREADS = 4 # How many threads to executed concurrently
		#Saves the tasks in a que to regulate num of threads
		queue = Queue.new

		Email.all.each do |email| # Go through all emails and check if theres no case attached

			if email.case.blank?
				email.case = Case.new
			end

			if email.category.blank?
				queue.push(email)
			end
		end

		#Start executing the threads
		ThreadedFilterEmail.new.execute_filter_threads(queue, @NUM_OF_THREADS)
		return true
	end




end
#end