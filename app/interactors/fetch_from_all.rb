class FetchFromAll

  attr_accessor :only_unseen

	def initialize(only_unseen = true)
		@email_accounts = EmailAccount.all
  	@only_unseen = only_unseen
	end

	def perform
    q1 = Queue.new
    q2 = Queue.new

		@email_accounts.each do |email_acc|
		  oneQ = FetchFromOne.new(email_acc, @only_unseen).perform
      oneQ.length.times do
        e = oneQ.pop
        q1.push(e)
        q2.push(e)
      end
		end
    CountWords.new.count_queue(q1)
    ThreadedFilterEmail.new.execute_filter_threads(q2)
	end
end