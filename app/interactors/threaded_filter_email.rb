class ThreadedFilterEmail
	require 'thread'
    #TODO

    #Accepts a que with emails that's going to be categorized, and how many threads it should do it in
    def execute_filter_threads(queue, num_of_threads)
        @active_threads = 0
        @lock = Mutex.new
        @thread_array = Array.new
        @all_categories = Category.all
        #print "\n\n LENGTH", queue.length, "<- length\n\n"
        #print "num of threads used: ", num_of_threads, "\n\n"
        #print "first category: ", @all_categories.fetch(0).name , "\n"
        #If I dont do this, the keywords & email addresses will be nil

        @task_queue = queue
        activate
        @email_queue = Queue.new

        #start threads & add them to array for later joining
        num_of_threads.times do
            @thread_array.push(Thread.new {perform_task})
        end

        #join all threads
        @thread_array.map(&:join)
        #print "Threads joined!!\n"
        #Save all emails and add case to category if it exists in queue
        @email_queue.length.times do
            temp_email = @email_queue.pop
            unless temp_email.category.blank?
                #add case to category

                temp_email.category.cases << temp_email.case
                #print "temp_email.category: ", temp_email.category.name, "\n"
            end
            temp_email.save
            #print "temp_email.category: ", temp_email.category.name, "\n"
        end
        #print_all_emails

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
        #print "\n\n TASK LENGTH", @task_queue.length, "<- length\n\n"
        #print "PRINT KEYWORDS\n\n"
        @all_categories.each do |cat|
            print cat.name, ":\n"
            cat.key_words.each do |key|
                print key.word, "\n"
            end
            cat.email_accounts.each do |acc|
                print acc.email_address, "\n"
            end
        end
        #print "DONE PRINT!!!!\n\n"
    end

    def print_all_emails
        Email.all.each do |email|
            #print "email.category.name: ", email.category.name, "\n"
        end
    end

end