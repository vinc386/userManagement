require 'digest'
class User < ActiveRecord::Base
  # == Schema Information
  #
  # Table name: users
  #
  #  id         :integer         not null, primary key
  #  username   :string(255)
  #  email      :string(255)
  #  fname      :string(255)
  #  lname      :string(255)
  #  created_at :datetime
  #  updated_at :datetime
  #  password   :string(255)
  #
  has_and_belongs_to_many :roles
  attr_accessor :password
  attr_accessible :username, 
                  :email, 
                  :fname, 
                  :lname, 
                  :password, 
                  :password_confirmation
  
  valid_email_format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :username, :presence => true,
                       :uniqueness => {:case_sensitive => false},
                       :length => { :within => 4..16}

  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 4..50}
                       
  validates :email, :presence => true,
                    :uniqueness => { :case_sensitive => false},
                    :format => { :with => valid_email_format}
                    
  validates :fname, :presence => true,
                    :length => { :within => 2..30}
  
  validates :lname, :presence => true,
                    :length => { :within => 2..30}


  before_save :encrypt_password
  
  def has_password?(submitted_password) 
    # Comparing encrypted_password with the encrypted version of submitted_password.
    encrypted_password == encrypt(submitted_password)
  end
  
  
  private
  
  def encrypt_password 
    self.salt = create_salt if new_record?
    self.encrypted_password = encrypt(self.password)
  end
  
  def encrypt(string) 
    secure_hash("#{salt}--#{string}")
  end
  
  def create_salt 
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string) 
    Digest::SHA2.hexdigest(string)
  end
end


