class WordcountController < ApplicationController

def index
	@term = Term.all
end

def start_counting
	count_words_for_all_mails
end

def count_words_for_all_mails
	CountWords.new.count
	return true
end

end