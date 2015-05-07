class WordcountController < ApplicationController

def index
	@term = Term.all
	@emails = Email.all
end

def count

	Email.all.each do |email|

			subjectArray = splitSubject(email)
			bodyArray = splitBody(email)

			subjectArray.each do |subjectword|
				if checkTerm(subjectword) == false
					createTerm(subjectword)
				else	
					addAmount(subjectword)
				end
			end
			
			bodyArray.each do |bodyword|
				if checkTerm(bodyword) == false
					createTerm(bodyword)
				else
					addAmount(bodyword)
				end
			end
	end
end

def checkTerm(emailword)

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

def createTerm(emailword)

	new_term = Term.new(word: emailword, amount: 1)
	new_term.save

end

def addAmount(emailword)

	Term.all.each do |term|
		if emailword.eql? term.word.downcase
			term.amount += 1
			term.save
			break
		end
	end
end

def splitSubject(email)
	
	email.subject.downcase.split
end

def splitBody(email)
	
	email.body.downcase.split
end

end