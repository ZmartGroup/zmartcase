class Email < ActiveRecord::Base
  attr_accessible :body, :case_id, :subject
  belongs_to :case
  belongs_to :type
  belongs_to :category
  
  #testCommentLine

   #Creates a new mail
    def initialize(subject, body,toAddress,fromAddress)
      @mailSubject=subject
      @mailBody=body
      @mailToAddress = toAddress
      @mailFromAddress = fromAddress
    end
    
    def getBody()
      return @mailBody.to_s
    end
    
    def getSubject()
      return @mailSubject.to_s
    end
    
    def setCategory(category)
      @mailCategory = category
    end
    
    def getCategory()
      return @mailCategory
    end
    
    def getMailToAddress
      return @mailToAddress
    end

end

##test 3 i email
