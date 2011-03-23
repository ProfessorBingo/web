Given /^I fill in the same '(.*)' as '(.*)' into '(.*)'$/ do |attribute, user, field|
  attrs = Factory.attributes_for(user.to_sym)
  fill_in(field, :with => attrs[attribute.to_sym])
end

Given /^I fill in valid details for '(.*)'$/ do |user|
  attrs = Factory.attributes_for(user.to_sym)
  attrs.each do |key, value|
    fill_in(key.to_s, :with => value)
  end
end

Given /^I see '(.*)'$/ do |text|
  page.should have_content(text)
end

Then /^I should not see '(.*)'$/ do |text|
  page.should_not have_content(text)
end

Given /^I fill in '(.*)' for '(.*)'$/ do |value, field|
  fill_in(field, :with => value)
end

When /^I click '(.*)'$/ do |link|
  click_link(link)
end

When /^I click the '(.*)' button$/ do |button|
  click_button(button)
end

Then /^I should see '(.*)'$/ do |text|
  page.should have_content(text)
end

When /^I visit '(.*)'$/ do |page|
  visit page
end

Then /^'(.*)' should contain '(.*)'$/ do |field, value|
  find_field(field).value.should == value
end

Then /^the user '(.*)' should exist$/ do |email|
  Student.first(:email => email)
end