require 'digest/sha1'

class User < ActiveRecord::Base
  before_create :hash_password
  has_many :orders, :foreign_key => :created_by_id

  private 
  def hash_password
    chars = ("a".."z").to_a + ("1".."9").to_a
    salt = Array.new(8, '').collect{chars[rand(chars.size)]}.join
    self.salt = salt
    self.password = self.class.sha1(password, salt)
  end

  def self.sha1(pass, salt)
    Digest::SHA1.hexdigest(salt + pass)
  end

end
