class FilterMailController < ApplicationController
	#coding: UTF-8

	def index
		@emails = Email.all
		#generate_random_emails(10)
		#remove_all_cases_and_categories_from_emails
	end


	#Filters all mails that has no category or case assigned to it
	#This will not be used when in production
	def start_filtering
		require 'thread'
		@debug = true
		@NUM_OF_THREADS = 4

		#Saves the tasks in a que to regulate num of threads
		queue = Queue.new

		logger.debug "\n\n\n\nSTART Filtering: "

		Email.all.each do |email| # Go through all emails and check if theres no case attached
			#if email.category.blank? #or email.case.blank?
			if email.case.blank?
				if false #@debug
					Rails.logger.debug "\nFiltering mail with from: "
					Rails.logger.debug email.from
					Rails.logger.debug "\n"
				end
				queue.push(email) 
			end
		end


		Rails.logger.debug "\n\n\n QUE made, returning to index...\n\n"
		
	 	FilterEmail.new.filter_mail(Email.last)

		redirect_to filter_mail_index_path
		


		#Start executing the threads
		#execute_filter_threads(queue, @NUM_OF_THREADS)

		Rails.logger.debug "\n\n\n\n\n All threads done!!!!!!!!!!!!!!\n\n\n\n\n"

		Rails.logger.debug "\n END Filtering\n\n\n\n\n"
		#-------------------------------
		
	end




	#Accepts a que with emails that's going to be categorized, and how many threads it should do it in
	def execute_filter_threads(queue, num_of_threads)
		@active_threads = 0
		lock = Mutex.new

		while queue.length > 0 do 
			if @NUM_OF_THREADS > @active_threads # Checks so that not more than set threads run concurrently
				lock.synchronize{ # lock variable so that only one thread can access it
					@active_threads += 1
				}

				Rails.logger.debug "Num of threads: "
				Rails.logger.debug @active_threads
				Rails.logger.debug "\n"

				Thread.new do # Start the threads
					filter_mail(queue.pop)
					ActiveRecord::Base.connection.close
					lock.synchronize{
						@active_threads -=1
					}
				end
			else 
				sleep(10)
			end
		end 

	end






end
#end