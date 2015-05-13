require 'mail'

class Email < ActiveRecord::Base

<<<<<<< HEAD
  attr_accessible :from, :to, :date, :subject, :case_id, :body, :raw, :category_id, :is_sent
=======
  attr_accessible :from, :to, :date, :subject, :case_id, :body, :raw, :is_sent
>>>>>>> 67691026f8b37308186295e456e6138a171cdd84

  belongs_to :case
  belongs_to :type
  belongs_to :category
<<<<<<< HEAD

  mount_uploader :raw, ZmartUploader


  #Creates a new mail
=======
  mount_uploader :raw, ZmartUploader
>>>>>>> 67691026f8b37308186295e456e6138a171cdd84

  #Creates a new mail
 
  #validates :to, presence: true
  #validates :from, presence: true

  #Decompress the raw mail
  def get_decompressed_mail
  	@mail ||= Mail.new(ActiveSupport::Gzip.decompress(get_raw))
  end



  #Get the path for the raw mail
  def get_raw
  	 @data ||= File.read raw_path
  end

  def raw_path
    @tmp_path ||= self.raw.tap { |u| u.cache_stored_file! }.path
  end

<<<<<<< HEAD
=======
  #Decompress the raw mail
  def get_decompressed_mail
  	@mail ||= Mail.new(ActiveSupport::Gzip.decompress(get_raw))
  end



  #Get the path for the raw mail
  def get_raw
  	 @data ||= File.read raw_path
  end

  def raw_path
    @tmp_path ||= self.raw.tap { |u| u.cache_stored_file! }.path
  end
  
>>>>>>> 67691026f8b37308186295e456e6138a171cdd84
  def cleanup
    File.delete(raw_path) if File.exist?(raw_path)
  end
end

