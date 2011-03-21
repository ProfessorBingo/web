Given /^I see '(.*)'$/ do |text|
  #pending # express the regexp above with the code you wish you had
  page.should have_content(text)
end

When /^I click '(.*)'$/ do |link|
  #pending # express the regexp above with the code you wish you had
  click_link(link)
end

Then /^I should see '(.*)'$/ do |text|
  page.should have_content(text)
end

