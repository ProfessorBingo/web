class Professor
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String, :required => true
end

class Student
  include DataMapper::Resource
  
  property :id,          Serial
  property :first_name,  String, :required => true
  property :last_name,   String, :required => true
  property :email,       String, :required => true
  property :pwhash,      String, :required => true
  property :mobileauth,  String
  property :permissions, String, :accessor => :protected
  property :regtime,     Time, :required => true
  property :valid,       Boolean, :default => false, :required => true
  
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
    return nil if(u.nil? || !u.valid)
    return u if Student.encrypt(pass, login) == u.pwhash
  end
  # a more secure auth method where the client has pre hashed the password, Ideally we'd like to do this all the time
  def self.sauth(login, passhash)
    u = Student.first(:email => login, :pwhash => passhash)
    return nil if(u.nil? || !u.valid)
    pp "Apparently I didn't return nil..."
    return u
  end
  
  def regcode
    Digest::SHA1.hexdigest(self.email + self.pwhash)
  end
  
  def available?
    # Was the account registered more than 3 days ago AND has it NOT been validated
    ((Time.now.to_i - self.regtime.to_i)/60/60/24 > 3 && !self.valid)
  end
  
  def validate!(code, time_in_seconds)
    
    if(self.valid && time_in_seconds.to_i == self.regtime.to_i && code == self.regcode)
      return true
    end
    if(time_in_seconds.to_i == self.regtime.to_i && code == self.regcode && !self.available?)
      pp "User #{self.email} has been validated..."
      self.valid = true
      self.save
    else
      return false
    end
    return self.valid
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
    self.permissions = nil
  end
  def get_permissions
    if(!self.permissions.nil?)
      self.permissions
    else
      'standard'
    end
  end
end

class School
  include DataMapper::Resource
  
  property :id,         Serial
  property :name,  String, :required => true
  property :short, String
  property :emailext,  String, :required => true
end

class Board
  include DataMapper::Resource
  
  property :id,         Serial
end

class Mannerism
  include DataMapper::Resource
  property :id,         Serial
end
