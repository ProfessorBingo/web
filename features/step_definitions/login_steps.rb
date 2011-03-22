Given /^A user '(.*)' exists$/ do |user|
  pp Student.all
  s = Factory.create(user.to_sym)
  pp Student.all
end

Given /^I am logged in as '(.*)'$/ do |user|
    visit("/login")
    attrs = Factory.attributes_for(user.to_sym)
    fill_in("email", :with => attrs[:email])
    fill_in("password", :with => attrs[:password])
    click_button("Login")
end

