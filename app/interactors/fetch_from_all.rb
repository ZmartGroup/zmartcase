class FetchFromAll
	#CONSTRUCTOR
	def initialize(only_unseen = true)
		@email_accounts = EmailAccount.all
    	@only_unseen = only_unseen
      setup
	end

	def setup
    @fetchers = Array.new
  	@email_accounts.each do |email_acc|
      @fetchers.push FetchFromOne.new(email_acc, @only_unseen)
    end
	end

	def perform
    @fetchers.each do |fetcher|
      fetcher.perform
    end
  end
end