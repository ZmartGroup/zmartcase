require 'mail'

class Email < ActiveRecord::Base
  scope :sent, -> {where(is_sent: true)}
  scope :received, -> {where(is_sent: false)}

  attr_accessible :from, :to, :date, :subject, :case_id, :body, :raw, :category_id, :is_sent, :case


  belongs_to :case
  belongs_to :type
  belongs_to :category

  mount_uploader :raw, ZmartUploader

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
end

