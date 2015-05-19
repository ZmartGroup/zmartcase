class ThreadedFilterEmail
	require 'thread'
    #TODO
    #thread does not exit correctly
    #join threads


    #Accepts a que with emails that's going to be categorized, and how many threads it should do it in
    def execute_filter_threads(queue, num_of_threads)
        #require 'thread'
        @active_threads = 0
        @lock = Mutex.new
        @thread_array = Array.new
        @all_categories = Category.all

        #If I dont do this, the keywords & email addresses will be nil
        activate

        @task_queue = queue
        @email_queue = Queue.new

        #start threads
        num_of_threads.times do
            @thread_array.push(Thread.new {perform_task})
        end

        #join all threads
        @thread_array.map(&:join)
        #print "Threads joined!!\n"

         #Save all emails in queue
        @email_queue.length.times do
            temp_email = @email_queue.pop
            unless temp_email.category.blank?
                temp_email.category.cases << temp_email.case
            end
            temp_email.save
        end
    end

    def perform_task
        email = nil
        begin
            while email = @task_queue.pop(true)
                @email_queue.push(FilterEmail.new(@all_categories).filter_mail(email,threaded=true))
            end
        end
        rescue ThreadError
    end

    #Needs to be done, otherwise no keywords will work
    def activate
        #print "PRINT KEYWORDS\n\n"
        @all_categories.each do |cat|
            #print cat.name, ":\n"
            cat.key_words.each do |key|
                #print key.word, "\n"
            end
            cat.email_accounts.each do |acc|
                #print acc.email_address, "\n"
            end
        end
        #print "DONE PRINT!!!!\n\n"
    end

end