class FilterMailController < ApplicationController
	#coding: UTF-8

	def index
		@emails = Email.all
		@categories = Category.all
		#TempStuff.new.generate_random_emails(1)
	end


	#Filters all mails that has no category assigned to it
	def start_filtering
		filter_all_emails

		redirect_to filter_mail_index_path

	end

	def filter_all_caseless_emails(num_of_threads = 4)

		#Saves the tasks in a que to regulate num of threads
		queue = Queue.new

		Email.all.each do |email| # Go through all emails and check if theres no case attached
			if  email.case.blank?
				email.case = Case.new
				queue.push(email)
			end
		end

		#Start executing the threads
		ThreadedFilterEmail.new.execute_filter_threads(queue, num_of_threads)
		return true
	end

	def filter_all_emails(num_of_threads = 4)

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
		ThreadedFilterEmail.new.execute_filter_threads(queue, num_of_threads)
		return true
	end




end
#end