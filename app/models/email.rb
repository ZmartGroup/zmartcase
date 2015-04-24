class Email < ActiveRecord::Base
  attr_accessible :body, :case_id, :subject
  belongs_to :case
  belongs_to :type
  belongs_to :category

  
  attr_accessor :category
  attr_reader :body, :subject, :mail_body, :mail_to_address
  
   #Creates a new mail
    def initialize(subject, body,to_address,from_address)
      @mail_subject       = subject
      @mail_body          = body
      @mail_to_address    = toAddress
      @mail_from_address  = from_address
    end
    
    def get_body()
      return @mail_body.to_s
    end
    
    def get_subject()
      return @mail_subject.to_s
    end
    
    def set_category(category)
      @mail_category = category
    end
    
    def get_category()
      return @mail_category
    end
    
    def get_mail_to_address
      return @mail_to_address
    end



end

##test 3 i email
