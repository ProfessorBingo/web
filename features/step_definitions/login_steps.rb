Given /^A user '(.*)' exists$/ do |user|
  s = Factory.create(user.to_sym)
end

Given /^I am logged in as '(.*)'$/ do |user|
    visit("/login")
    attrs = Factory.attributes_for(user.to_sym)
    fill_in("email", :with => attrs[:email])
    fill_in("password", :with => attrs[:password])
    click_button("Login")
end

Then /^I should see Welcome '(.*)'$/ do |user|
  attrs = Factory.attributes_for(user.to_sym)
  
  page.should have_content("Welcome " + attrs[:email])
end