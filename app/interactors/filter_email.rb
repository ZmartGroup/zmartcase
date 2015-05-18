class FilterEmail
    #TODO:

    #remove prints
    #clean code
    #fix accounts.find_each


    def initialize(categories=Category.all)
        @all_categories = categories
    end


    #finds a case for the email or if non is found creates a new one and categorises it
    def filter_mail(email, threaded=false)
        print "Start filter_email"

        unless check_email_addresses(email)
            #Second check each word in subject and body against keywords in categories
            check_subject_and_body(email)
        end
        print "RETURNING EMAIL !!!!!!!!!!!\n"
        if !threaded
            email.save
            email.category.cases << email.case
        end
        return email
    end

    #Checks the email address in the email against the email addresses in each category
    def check_email_addresses(email)
        print "Start check email\n"
        @all_categories.each do |cat|
            accounts = cat.email_accounts
            #accounts.find_each(:conditions => "email_address.eql? email.to.downcase") do
            #    attach_case_to_category(email,cat)
            #    return true
            #end
            accounts.each do |to|
                if to.email_address.downcase.eql? email.to.downcase
                    attach_category_to_email(email,cat)
                    #attach_case_to_category(email, cat)
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

        subject_words = SeperateWords.new.seperate(email.subject)

        body_words = SeperateWords.new.seperate(email.body)

        print "STARTING!\n"
        #print "FIRST cat.name: ",  @this_categories.first.name, "\n"
        @all_categories.each do |cat|
        #@this_categories.each do |cat|
            #print "cat.name: ", cat.name, "\n"
            #print "key words: \n"

            #cat.key_words.each do |key|
            #    print key.word, "\n"
            #end
            #print "End all print all keywords\n\n"
            #Checks each word in subject and body against keywords in categories
            temp_points += check_words(cat.key_words, subject_words, true)

            #BODY
            temp_points += check_words(cat.key_words, body_words)

            if temp_points > points
                print "WINS!!!!!!!!!!!!!!!!!!! \n\n"
                points = temp_points
                winning_category = cat
                #attach_category_to_email(email,cat)
                #attach_case_to_category(email, cat)
                #print "Cat name: ", cat.name , "\n"
            end
            temp_points = 0
        end
        #BETTER, this way removes unesseccary transactions
        if !winning_category.blank?
            attach_category_to_email(email,winning_category)
            #attach_case_to_category(email, winning_category)
        else
            print "no winning category\n\n"
        end
        print " DONE check_subject_and_body\n"
    end

    def attach_category_to_email(email,cat)
        print "Adding CATEGORY to email \n"
        print "Cat name: ", cat.name ,"\n"
        #print "Email subject: ", email.subject, "\n"
        email.category = cat
        #Does not work with threads
        #email.save
        print "DONE ADDING CATEGORY TO EMAIL \n"

        #return email
    end

    def attach_case_to_category(email, cat)
        #require 'thread'
        #@lock.synchronize{
            #Works
            #print "cat id: ", cat.cases.first.id, "\n"
            #print "email id: ", email.case.id, "\n"
            #cat.cases << email.case
            #cat.cases.push(email.case)
            #funkar ej
            #email.case.category = cat
        #}
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
        #print "check_key_words: END, Points awarded: ", temp_points, "\n\n"
        return temp_points

    end

    #def insert_case_in_category(case, cat)
    #    inserts = []
    #    time = Time.now.to_s(:db)
    #    #self.job.
    #    sql ="INSERT INTO categories"
    #end

end