class ThreadedFilterEmail
	require 'thread'



    #Accepts a que with emails that's going to be categorized, and how many threads it should do it in
    def execute_filter_threads(queue, num_of_threads)
        require 'thread'
        @active_threads = 0
        @lock = Mutex.new
        #@all_categories = Category.all
        #print "START THREADS\n\n"
        while queue.length > 0 do
            if num_of_threads > @active_threads # Checks so that not more than set threads run concurrently
                @lock.synchronize{ # lock variable so that only one thread can access it
                    @active_threads += 1
                }

                #print "Num of threads: ", @active_threads, "\n"

                Thread.new do # Start the threads
                    this_thread = @active_threads
                    #print "new thread: ", this_thread, "\n"
                    FilterEmail.new.filter_mail(queue.pop)
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
        #sleep(4)
        #print "Filters done, done sleeping \n"
    end

end