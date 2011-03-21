Given /^A user '(.*)' with password '(.*)' exists$/ do |email, pass|
  s = Student.first_or_new
  s.first_name='First'
  s.last_name='First'
  s.email=email
  s.password=pass
  s.save
end