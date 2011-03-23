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

Given /^I am viewing '(.*)' of '(.*)'$/ do |page, user|
  attrs = Factory.attributes_for(user.to_sym)
  pp path_to(page) + attrs[:email] + "/"
  visit(path_to(page) + attrs[:email] + "/")
end

Then /^the '(.*)' radio button should be checked$/ do |name|
  page.should have_selector 'input[type=radio][checked=checked][id=' + name + ']'
end