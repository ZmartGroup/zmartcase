class ThreadedFilterEmail
	require 'thread'
    #TODO
    #thread does not exti correctly
    #join threads


    #Accepts a que with emails that's going to be categorized, and how many threads it should do it in
    def execute_filter_threads(queue, num_of_threads)
        require 'thread'
        @active_threads = 0
        @lock = Mutex.new

        @all_categories = Category.all

        #IF I dont do this, the keywords will be nil
        activate_keywords
        
        task_queue = queue
        email_queue = Queue.new

        num_of_threads.times do
            Thread.new do # Start the threads
                continue = true
                email = nil
                #@lock.synchronize do
                    @active_threads += 1
                    this_thread = @active_threads
                #end
                
                while continue
                    @lock.synchronize do
                        print "Thread nr: ", this_thread, " Check if que is empty? Que length: ", task_queue.length, "\n"
                        if task_queue.length!=0
                            print "que not empty\n"
                            email = task_queue.pop
                        else
                            print "que empty\n"
                            email = nil
                        end
                    end
                    

                    #while email = @task_queue.pop
                    @lock.synchronize do
                        print "Thread nr: ", this_thread, ": ", email.subject, "<---subject, task_queue.length: ", task_queue.length, "\n"
                    end
                    unless email == nil
                        #@lock.synchronize do
                        #    print email.subject, "<-email subject.  FILTERING IT!!!\n\n"
                        #end
                        email_queue.push(FilterEmail.new(@all_categories).filter_mail(email,threaded=true))
                    else
                        @lock.synchronize do
                            print "Thread nr: ", this_thread," continue set to false\n"
                        end
                        continue = false
                    end
                    @lock.synchronize do
                        print "THREAD nr: ", this_thread, " at end of while loop \n"
                    end
                end

                #@lock.synchronize do
                    print "THREAD nr: ", this_thread, " DONE!!!!!!!!!!!!! \n\n"
                #end

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

    #Needs to be done, otherwise no keywords will work
    def activate_keywords
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