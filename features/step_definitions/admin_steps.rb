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
  visit(path_to(page) + attrs[:email] + "/")
end

Then /^the '(.*)' radio button should be checked$/ do |name|
  page.should have_selector 'input[type=radio][checked=checked][id=' + name + ']'
end

Given /^the '(.*)' radio button is checked$/ do |name|
  page.should have_selector 'input[type=radio][checked=checked][id=' + name + ']'
end

Given /^my current url is '(.*)'$/ do |path|
  visit(path)
end

Given /^[Aa] school '(.*)' exists$/ do |school|
  attrs = Factory.attributes_for(school.to_sym)
  if(!School.first(:name => attrs[:name]))
    Factory.create(school.to_sym)
  end
end