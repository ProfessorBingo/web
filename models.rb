class Professor
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String, :required => true
end

class Student
  include DataMapper::Resource
  
  property :id,         Serial
  property :first_name, String, :required => true
  property :last_name,  String, :required => true
  property :email,      String, :required => true
  property :pwhash,     String, :required => true
  property :mobileauth, String
  
  def password=(pass)
    self.pwhash = Student.encrypt(pass, self.email.to_s)
  end
  # def emailaddress=(email)
  #   puts "callingemail"
  #   @emailforencrypt = email
  #   self.email = email
  # end

  def self.encrypt(pass, salt)
    totalpword = pass + salt
    Digest::SHA1.hexdigest(totalpword)
  end

  def self.auth(login, pass)
    u = Student.first(:email => login)
    return nil if u.nil?
    return u if Student.encrypt(pass, login) == u.pwhash
  end
  # a more secure auth method where the client has pre hashed the password, Ideally we'd like to do this all the time
  def self.sauth(login, passhash)
    u = Student.first(:email => login, :pwhash => passhash)
    return nil if u.nil?
    return u
  end
end

class School
  include DataMapper::Resource
  
  property :id,         Serial
  property :name, String, :required => true
end

class Board
  include DataMapper::Resource
  
  property :id,         Serial
end

class Mannerism
  include DataMapper::Resource
  property :id,         Serial
end
