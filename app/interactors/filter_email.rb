class FilterEmail
    #TODO:

    def initialize(categories=Category.all)
        #if threaded categories needs to be sent from the caller
        @all_categories = categories
    end

    #finds a category for the email
    #if the code is not threaded, it will save and add the case to the email before exiting.
    def filter_mail(email, threaded=false)

        unless check_email_addresses(email) #first check if email address matches category
            check_subject_and_body(email) #Second check each word in subject and body against keywords in categories
        end

        if !threaded
            email.save
            email.category.cases << email.case
        end

        return email
    end

    #Checks the email address in the email against the email addresses in each category
    def check_email_addresses(email)
        @all_categories.each do |cat|
            cat.email_accounts.each do |account|
                #see if theres a matching email address
                if account.email_address.downcase.eql? email.to.downcase
                    attach_category_to_email(email,cat)
                    return true
                end
            end
        end
        return false
    end

    #Checks each word against keywords in categories
    def check_subject_and_body(email)
        winning_category = nil
        temp_points = 0 #The score for the current category
        points = 0 # The highest score achived

        subject_words = SeperateWords.new.seperate(email.subject)
        body_words = SeperateWords.new.seperate(email.body)

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
        #This way removes unesseccary transactions
        attach_category_to_email(email,winning_category) unless winning_category.blank? 
    end

    def attach_category_to_email(email,cat)
        email.category = cat
    end

    #check each word in either subject or body against the keywords in each category's key_words
    def check_words(key_words, words, is_subject = false)
        temp_points = 0
        words.each do |word|
            temp_points += check_key_words(word, key_words, is_subject)
        end
        return temp_points
    end

    #check each word against each keyword
    def check_key_words(word, key_words, is_subject = false)
        temp_points = 0
        key_words.each do |key|
            if key.word.downcase.eql? word.downcase
                is_subject ? temp_points += key.point * 2 : temp_points += key.point
            end
        end
        return temp_points

    end

end