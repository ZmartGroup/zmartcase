class FilterEmail
    def initialize
        @all_categories = Category.all
    end

    #Accepts a que with emails that's going to be categorized, and how many threads it should do it in
    def execute_filter_threads(queue, num_of_threads)
        require 'thread'
        @active_threads = 0
        @lock = Mutex.new
        #@all_categories = Category.all
        print "START THREADS\n\n"
        @all_categories.each do |cat|
            print "cat.name: ", cat.name, " cat.key_words.length: ", cat.key_words.length, "\n\n"
        end

        while queue.length > 0 do
            if num_of_threads > @active_threads # Checks so that not more than set threads run concurrently
                @lock.synchronize{ # lock variable so that only one thread can access it
                    @active_threads += 1
                }

                print "Num of threads: ", @active_threads, "\n"

                Thread.new do # Start the threads
                    this_thread = @active_threads
                    print "new thread: ", this_thread, "\n"
                    filter_mail(queue.pop)
                    puts "poped from que, length of que: ", queue.length, "\n"
                    ActiveRecord::Base.connection.close
                    @lock.synchronize{
                        @active_threads -=1
                    }
                    print "thread: ", this_thread, " done! \n"
                end
            else
                sleep(0.001)
            end
        end
        sleep(4)
        print "Filters done, done sleeping \n"
    end

    #Checks if theres a prior case to add email to. Otherwise returns false
    def check_case(email)

        #print "check_case email.subject: ", email.subject, "\n"
        if email.case_id.blank?
            return false
        else
            return true
        end
    end

    #finds a case for the email or if non is found creates a new one and categorises it
    def filter_mail(email)
        find_category(email) #and finally place that case in a category
    end



    #Starts the proccess to find a category for an email
    def find_category(email)
        #Check each category's email address to see if it fits:
        unless check_email_addresses(email)
            #Second check each word in subject and body against keywords in categories
            check_subject_and_body(email)
        end
    end

    #Checks the email address in the email against the email addresses in each category
    def check_email_addresses(email)
        Category.all.each do |cat|

            accounts = cat.email_accounts
            #accounts.find_each(:conditions => "email_address.eql? email.to.downcase") do
            #    attach_case_to_category(email,cat)
            #    return true
            #end
            accounts.each do |to|
                if to.email_address.downcase.eql? email.to.downcase
                    attach_category_to_email(email,cat)
                    attach_case_to_category(email, cat)
                    return true
                end
            end
        end
        return false
    end



    #Checks each word against keywords in categories
    def check_subject_and_body(email)
        winning_category = nil
        #Used to settle which word to use.
        temp_points = 0 #The score for the current category
        points = 0 # The highest score achived


        # DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!
        #Seperate the words in the subject
        #These will need to be improved since they don't work properly with swedish charaters
        subject_words = email.subject.scan(/\w+/)
        body_words = email.body.scan(/\w+/)

        # DOEST NOT WORK WITH SWEDISH CHARACTERS!!!!!!!!!!!!!!!!!!!!!!!


        #Category.all.each do |cat|
        @all_categories.each do |cat|

            #Checks each word in subject and body against keywords in categories
            temp_points += check_words(cat.key_words, subject_words, true)

            #BODY
            temp_points += check_words(cat.key_words, body_words)

            if temp_points > points

                points = temp_points
                winning_category = cat

            end
            temp_points = 0
        end
        attach_category_to_email(email,winning_category)
        attach_case_to_category(email, winning_category)
    end

    def attach_category_to_email(email,cat)
        print "Adding CATEGORY to email \n"
        email.category = cat
        #email.save
        print "DONE ADDING CATEGORY TO EMAIL \n"
    end

    def attach_case_to_category(email, cat)
        require 'thread'
        print "trying to add email case to category\n"
        cat.cases << email.case
        print "done w case\n"
    end

    #check each word in either subject or body against the keywords in each category's key_words
    def check_words(key_words, words, is_subject = false)
        #print "check_words: \n"
        temp_points = 0
        words.each do |word|
            temp_points += check_key_words(word, key_words, is_subject)
        end
        #print "check_words: Points awarded:", temp_points, "\n"
        return temp_points
    end

    #check each word against each keyword
    def check_key_words(word, key_words, is_subject = false)
        #print "check_key_words: \n ", word, "\n key_words.length: ", key_words.length, "\n\n"
        temp_points = 0
        key_words.each do |key|
            #print "checking word: ", key.word ,"\n\n"
            if key.word.downcase.eql? word.downcase
                if is_subject
                    #if found in subject score * 2
                    temp_points += key.point * 2
                else
                    temp_points += key.point
                end

            end
        end
        return temp_points
        #print "check_key_words: END, Points awarded: ", temp_points, "\n\n"
    end

end