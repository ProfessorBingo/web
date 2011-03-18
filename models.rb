class Professor
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String, :required => true
end

class Student
  include DataMapper::Resource
  
  property :id,         Serial
  property :name_first, String, :required => true
  property :name_last,  String, :required => true
  property :email,      String, :required => true
  property :pwhash,     String, :required => true
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
