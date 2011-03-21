Given /^I see '(.*)'$/ do |text|
  #pending # express the regexp above with the code you wish you had
  page.should have_content(text)
end

Given /^I fill in '(.*)' for '(.*)'$/ do |value, field|
  fill_in(field, :with => value)
end

When /^I click '(.*)'$/ do |link|
  #pending # express the regexp above with the code you wish you had
  click_link(link)
end

When /^I click the '(.*)' button$/ do |button|
  click_button(button)
end

Then /^I should see '(.*)'$/ do |text|
  page.should have_content(text)
end

Then /^'(.*)' should contain '(.*)'$/ do |field, value|
  find_field(field).value.should == value
end

Then /^the user '(.*)' should exist$/ do |name|
  Student.first(:username => name)
end