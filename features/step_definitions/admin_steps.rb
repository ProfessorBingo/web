When /^click '(.*)'$/ do |item|
  click_on(item)
end

When /^I choose '(.*)'$/ do |field|
  choose(field)
end

Given /^I make '(.*)' a '(.*)'$/ do |user, type|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  s.send(type + "!")
  s.save
  s.send(type + "?").should == true
end