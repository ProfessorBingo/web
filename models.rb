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
  
  def password=(pass)
    @password = pass
    self.pwhash = Student.encrypt(@password, self.email.to_s)
  end  

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + self.email.to_s)
  end

  def self.auth(login, pass)
    u = Student.first(:email => login)
    return nil if u.nil?
    return u if Student.encrypt(pass, self.email.to_s) == u.pwhash
    puts Student.encrypt(pass, self.email.to_s)
    nil
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
