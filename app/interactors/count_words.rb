class CountWords

	##################FIXA SÅ ATT REDAN GENOMSKANNADE MAIL INTE SKANNAS IGEN
	
	def count

	Email.all.each do |email|

			subjectArray = seperate_words(email.subject)
			bodyArray = seperate_words(email.body)

			subjectArray.each do |subjectword|
				if check_term(subjectword) == false
					create_term(subjectword)
				else	
					add_amount(subjectword)
				end
			end
			
			bodyArray.each do |bodyword|
				if check_term(bodyword) == false
					create_term(bodyword)
				else
					add_amount(bodyword)
				end
			end
	end
end

def check_term(emailword)

	if Term.all == []
		create_term("hej")
	end

	state = true

	Term.all.each do |term|
		if emailword.eql? term.word.downcase
			state = true
			break
		else
			state = false
		end
	end

	state

end

def create_term(emailword)

	Term.create(word: emailword, amount: 1)

end

def add_amount(emailword)

	Term.all.each do |term|
		if emailword.eql? term.word.downcase
			term.amount += 1
			term.save
			break
		end
	end
end

def seperate_words(emailword)

	SeperateWords.new.seperate(emailword)

end

end