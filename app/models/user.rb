require 'digest/sha1'
require 'digest/sha2'

class User < ActiveRecord::Base
  set_table_name :users
  set_primary_key :user_id

  has_many :user_roles, :foreign_key => :username, :primary_key => :username, :dependent => :destroy
  has_many :user_books, :foreign_key => :user_id
  has_many :books, :through => :user_books

  validates_uniqueness_of :username, :message => ' already taken'
  validates_uniqueness_of :email, :message => ' already taken'

  #before_save :set_password

  cattr_accessor :current_user

  def try_to_login
    User.authenticate(self.username,self.password)
  end

  def self.authenticate(login, password)
    u = find :first, :conditions => {:username => login}
    u && u.authenticated?(password) ? u : nil
  end

  def authenticated?(plain)
    encrypt(plain, salt) == password || Digest::SHA1.hexdigest("#{plain}#{salt}") == password || Digest::SHA512.hexdigest("#{plain}#{salt}") == password
  end

  def encrypt(plain, salt)
    encoding = ""
    digest = Digest::SHA1.digest("#{plain}#{salt}")
    (0..digest.size-1).each{|i| encoding << digest[i].to_s(16) }
    encoding
  end

  def set_password
    self.salt = User.random_string(10) if !self.salt?
    self.password = User.encrypt(self.password,self.salt)
  end

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def self.encrypt(password,salt)
    Digest::SHA1.hexdigest(password+salt)
  end

  def role
    user_roles = self.user_roles
    return "" if user_roles.blank?
    return user_roles.last.role
  end

  def has_book?(book)
    return false if self.books.blank?
    return true if self.books.include?(book)
    return false
  end

end

