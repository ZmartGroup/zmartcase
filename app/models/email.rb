class Email < ActiveRecord::Base

  attr_accessible :body, :case_id, :subject, :subject, :to, :from

  belongs_to :case
  belongs_to :type
  belongs_to :category
  
   #Creates a new mail

  #validates :to, presence: true
  #validates :from, presence: true


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

