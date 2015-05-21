class WordcountController < ApplicationController

def index
	@terms = Term.all
	@emails = Email.all
end

end