class Professor
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String, :required => true
end

class Category
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String, :required => true
end

class Student
  include DataMapper::Resource
  
  property :id,          Serial
  property :first_name,  String, :required => true, :messages => { :presence  => 'A First Name is required.' }
  property :last_name,   String, :required => true, :messages => { :presence  => 'A Last Name address is required.' }
  property :email,       String, :required => true, :unique => true,
  # line commented out for personal testing
  #:format => :email_address,
  :messages => {
        :presence  => 'An email address is required.',
        :is_unique => 'That school name is already taken.',
        :format => 'Please make sure you entered your email address as `xxxxx@xxxx.xxx`.'
      }
  property :pwhash,      String, :required => true
  property :mobileauth,  String
  property :permissions, String, :accessor => :protected, :required => true, :default => 'standard'
  property :regtime,     Time, :required => true
  property :item_enabled,Boolean, :default => false, :required => true

  belongs_to :school, :required => false
#  before :save, :categorize
  before :save, :set_school
  
  
  
  def password=(pass)
    self.pwhash = Student.encrypt(pass, self.email.to_s)
    self.regtime = Time.now
  end

  def self.encrypt(pass, salt)
    totalpword = pass + salt
    Digest::SHA1.hexdigest(totalpword)
  end

  def self.auth(login, pass)
    u = Student.first(:email => login)
    return nil if(u.nil? || !u.item_enabled)
    return u if Student.encrypt(pass, login) == u.pwhash
  end
  # a more secure auth method where the client has pre hashed the password, Ideally we'd like to do this all the time
  def self.sauth(login, passhash)
    u = Student.first(:email => login, :pwhash => passhash)
    pp u
    pp login
    pp passhash
    return nil if(u.nil? || !u.item_enabled)
    pp "Apparently I didn't return nil..."
    return u
  end
  
  def regcode
    Digest::SHA1.hexdigest(self.email + self.pwhash)
  end
  
  def available?
    # Was the account registered more than 3 days ago AND has it NOT been validated
    ((Time.now.to_i - self.regtime.to_i)/60/60/24 > 3 && !self.item_enabled)
  end
  
  def validate!(code, time_in_seconds)
    
    if(self.item_enabled && time_in_seconds.to_i == self.regtime.to_i && code == self.regcode)
      return true
    end
    if(time_in_seconds.to_i == self.regtime.to_i && code == self.regcode && !self.available?)
      pp "User #{self.email} has been validated..."
      self.item_enabled = true
      self.save
    else
      return false
    end
    return self.item_enabled
  end
  
  def superadmin?
    self.permissions == "superadmin"
  end
  def superadmin!
    self.permissions = "superadmin"
  end
  def admin?
    (!(self.permissions =~ /^(super)?admin$/).nil? && !self.permissions.nil?)
  end
  def admin!
    self.permissions = "admin"
  end
  def supermod?
    (!(self.permissions =~ /^((super)?(admin)?|supermod)$/).nil? && !self.permissions.nil?)
  end
  def supermod!
    self.permissions = "supermod"
  end
  def mod?
    (!(self.permissions =~ /^((super)?(admin|mod))$/).nil? && !self.permissions.nil?)
  end
  def mod!
    self.permissions = "mod"
  end
  def standard!
    self.permissions = "standard"
  end
  def get_permissions
    if(!self.permissions.nil?)
      self.permissions
    else
      'standard'
    end
  end
  def url_safe_email
    CGI::escape(self.email)
  end

  def set_school
    if(self.email)
      ext = self.email.scan(/^.*@(.*)$/)[0]
      pp ext
      self.school = School.first(:emailext => ext)
    end
  end
end

class School
  include DataMapper::Resource
  
  property :id,         Serial
  property :name, String, :required => true, :unique => true, 
  :messages => {
        :presence  => 'A school name is required.',
        :is_unique => 'That school name is already taken.'
      }
  property :short, String, :required => true
  property :emailext,  String, :required => true, :unique => true,
  :messages => {
        :presence  => 'You must enter an email extension for this school',
        :is_unique => "That school name is already taken."
      }
  property :item_enabled,       Boolean, :default => false, :required => true
  
  has n, :student
  
  def url_safe_name
    CGI::escape(self.name)
  end
end

class Board
  include DataMapper::Resource
  
  property :id,         Serial
end

class Mannerism
  include DataMapper::Resource
  property :id,         Serial
end
