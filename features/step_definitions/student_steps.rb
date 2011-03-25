Given /^'(\d+)' users exist$/ do |num_users|
  Student.all.count.should == num_users.to_i
end

Given /^more than '(\d+)' users exist$/ do |num_users|
  Student.all.count.should > num_users.to_i
end

Given /^'(.*)' is (?:a|an) '(.*)'$/ do |user, type|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  s.send((type + "?")).should == true rescue s.get_permissions.should == type
end

When /^I create a user '(.*)'$/ do |user|
  Factory.create(user.to_sym)
end

Then /^'(.*)' should not be (?:a|an) '(.*)'$/ do |user, type|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  s.send((type + "?")).should == false
end

Then /^'(.*)' should be (?:a|an) '(.*)'$/ do |user, type|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  s.send(type + "?").should == true
end

Given /^I want to see what is happening$/ do
  save_and_open_page
end

Then /^the '(.*)' of user '(.*)' should be '(.*)'$/ do |property, user, value|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  s.send(property).should == value
end