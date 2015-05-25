class MailFetcherJob
	include SuckerPunch::Job

	def perform(only_unseen = true)
		ActiveRecord::Base.connection_pool.with_connection do
      FetchFromAll.new(only_unseen).perform
		end
	end
end