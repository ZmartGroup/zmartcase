class FilterEmail
    #TODO:
    #Initilize should take an email
    #remove prints
    #fix accounts.find_each
    def initialize
        @all_categories = Category.all
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
        unless check_email_addresses(email)
            #Second check each word in subject and body against keywords in categories
            check_subject_and_body(email)
        end
    end

    #Checks the email address in the email against the email addresses in each category
    def check_email_addresses(email)
        #Category.all.each do |cat|
        @all_categories.each do |cat|
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

        subject_words = SeperateWords.new.seperate(email.subject)

        body_words = SeperateWords.new.seperate(email.body)

        #Category.all.each do |cat|
        #@all_categories = Category.all
        #print "FIRST cat.name: ", @all_categories.first.name, "\n"
        @all_categories.each do |cat|
            #print "cat.name: ", cat.name, "\n"
            #Checks each word in subject and body against keywords in categories
            temp_points += check_words(cat.key_words, subject_words, true)

            #BODY
            temp_points += check_words(cat.key_words, body_words)

            if temp_points > points
                #print "WINSSSS!!!! \n\n"
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
            attach_case_to_category(email, winning_category)
        else
            #print "no winning category"
        end
    end

    def attach_category_to_email(email,cat)
        #print "Adding CATEGORY to email \n"
        #print "Cat name: ", cat.name ,
        email.category = cat
        #email.save
        #print "DONE ADDING CATEGORY TO EMAIL \n"
    end

    def attach_case_to_category(email, cat)
        #require 'thread'
        #@lock.synchronize{
            #print "trying to add email case to category\n"
            #Works
            cat.cases << email.case
            #cat.cases.push(email.case)
            #funkar ej
            #email.case.category = cat

            #print "done w case\n"
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
        return temp_points
        #print "check_key_words: END, Points awarded: ", temp_points, "\n\n"
    end

    #def insert_case_in_category(case, cat)
    #    inserts = []
    #    time = Time.now.to_s(:db)
    #    #self.job.
    #    sql ="INSERT INTO categories"
    #end

end