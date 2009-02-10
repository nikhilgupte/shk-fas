require 'digest/sha1'

class User < ActiveRecord::Base
  before_create :create_salt
  before_save :hash_password
  has_many :orders, :foreign_key => :created_by_id

  validates_format_of :email_address, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :allow_blank => true
  validates_size_of :username, :minimum => 4, :allow_blank => true
  validates_uniqueness_of :username, :email, :case_sensitive => false
  validates_format_of :username, :with => /^\w+$/i, :message => "can only contain letters and numbers.", :allow_blank => true
  validates_presence_of :password, :username, :full_name, :email_address
  validates_size_of :password, :minimum => 8, :allow_blank => true
  validates_format_of :password, :with => %r{(\d)+(\w)+}i, :message => 'must be alpha-numeric'
  validates_confirmation_of :password

  def self.login(username, password)
    if user = find_by_username(username)
      if user.password_valid?(password)
        unless user.disabled?
          return user
        else
          raise 'Your account has been disabled. Please contact the FAS Administrator'
        end
      end
    end
    raise 'Invalid username or password'
  end

  def password_valid?(test_password)
    self.password == User.sha1(test_password, self.salt)
  end

  private 
  def create_salt
    chars = ("a".."z").to_a + ("1".."9").to_a
    salt = Array.new(8, '').collect{chars[rand(chars.size)]}.join
    self.salt = salt
  end

  def hash_password
    self.password = self.class.sha1(password, salt)
  end

  def self.sha1(pass, salt)
    Digest::SHA1.hexdigest(salt + pass)
  end

end
