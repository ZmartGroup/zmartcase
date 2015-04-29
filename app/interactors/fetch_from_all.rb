class FetchFromAll
	#CONSTRUCTOR
	def initialize(only_unseen = true)
		@email_accounts = EmailAccount.all
    @only_unseen = only_unseen
	end

	def perform
    @email_accounts.each do |email_acc|
      FetchFromOne.new(email_acc, @only_unseen).perform
    end
  end
end