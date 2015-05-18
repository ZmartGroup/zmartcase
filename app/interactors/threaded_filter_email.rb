class ThreadedFilterEmail
	require 'thread'
    #TODO
    #Change execute_filter_threads
    #join threads


    #Accepts a que with emails that's going to be categorized, and how many threads it should do it in
    def execute_filter_threads(task_queue, num_of_threads)
        require 'thread'
        @active_threads = 0
        @lock = Mutex.new

        @all_categories = Category.all

        #IF I dont do this, the keywords will be nil
        print_all_keywords

        email_queue = Queue.new

        while task_queue.length > 0 do
            if num_of_threads > @active_threads # Checks so that not more than set threads run concurrently
                @lock.synchronize{ # lock variable so that only one thread can access it
                    @active_threads += 1
                }

                #print "Num of threads: ", @active_threads, "\n"

                Thread.new do # Start the threads
                    this_thread = @active_threads
                    print "new thread: ", this_thread, "\n"
                    #FilterEmail.new(@all_categories).filter_mail(queue.pop)
                    test_cat = @all_categories.fetch(0)
                    print test_cat.name, "<- cat name \n"
                    email = task_queue.pop
                    email_queue.push(FilterEmail.new(@all_categories).filter_mail(email,threaded=true))
                    print "Adding cat to email in THREAD\n"


                    #puts "popped from que, length of que: ", queue.length, "\n"
                    ActiveRecord::Base.connection.close
                    @lock.synchronize{
                        @active_threads -=1
                    }
                    #print "thread: ", this_thread, " done! \n"

                end
            else
                sleep(0.001)
            end

        end
        #join all threads


        sleep(4)
        print "Filters done, done sleeping \n"
        #Save all emails in que
        while email_queue.length > 0 do
            temp_email = email_queue.pop
            unless temp_email.category.blank?
                print "trying to add email case to category\n"
                temp_email.category.cases << temp_email.case
            end
            print "done w case\n"
            temp_email.save
        end
        print " DONE!!!!!!!\n"
    end

    def print_all_keywords
        #print "PRINT KEYWORDS\n\n"
        @all_categories.each do |cat|
            #print cat.name, "\n"
            cat.key_words.each do |key|
                #print key.word, "\n"
            end
        end
        #print "DONE PRINT KEYWORDS\n\n"
    end

    def print_all_cases
        print "PRINT cases\n\n"
        @all_categories.each do |cat|
            print cat.name, "\n"
            cat.cases.each do |case1|
                print case1.id, "\n"
            end
        end
        print "DONE PRINT cases \n\n"
    end

end