Given /^'(\d+)' users exist$/ do |num_users|
  Student.all.count.should == num_users.to_i
end
Given /^more than '(\d+)' users exist$/ do |num_users|
  Student.all.count.should > num_users.to_i
end

When /^I create a user '(.*)'$/ do |user|
  Factory.create(user.to_sym)
end

Then /^'(.*)' should not be (?:a|an) '(.*)'$/ do |user, type|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  s.permissions.should_not == type
end

Then /^'(.*)' should be (?:a|an) '(.*)'$/ do |user, type|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  s.permissions.should == type
end