Given /^I am a valid API user$/ do
  @user = Factory(:user)
  authorize(@user.email, @user.password)
end

# Must run this one as rack_test!!!
Given /^I log in as '(.*)' via JSON$/ do |user|
  Capybara.current_driver = :rack_test
  u = Factory.build(user.to_sym)
  json_login = {'email' => u.email, 'password' => u.pwhash}.to_json
  rack_test_session_wrapper = Capybara.current_session.driver
  rack_test_session_wrapper.process :post, '/login' ,:data => json_login
end

# Must run this one as rack_test!!!
Given /^I log in as '(.*)' via JSON incorrectly$/ do |user|
  Capybara.current_driver = :rack_test
  u = Factory.build(user.to_sym)
  json_login = {'email' => u.email, 'password' => ''}.to_json
  rack_test_session_wrapper = Capybara.current_session.driver
  rack_test_session_wrapper.process :post, '/login' ,:data => json_login
end

When /^I send a POST request to "([^\"]*)" with the following:$/ do |path, body|
  post path, body
end

# Must run this one as rack_test!!!
When /^I log out as '(.*)' via JSON$/ do |user|
  Capybara.current_driver = :rack_test
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  json_logout = {'authcode' => s.mobileauth}.to_json
  rack_test_session_wrapper = Capybara.current_session.driver
  rack_test_session_wrapper.process :post, '/login' ,:data => json_logout
end

Then /^the JSON authcode I receive should be '(.*)'$/ do |authcode|
  jsonresult = JSON.parse(page.body)
  jsonresult['data']['authcode'].should == authcode
end

Then /^the JSON authcode I receive should not be '(.*)'$/ do |authcode|
  jsonresult = JSON.parse(page.body)
  jsonresult['data']['authcode'].should_not == authcode
  jsonresult['data']['authcode'].should_not == ''
  jsonresult['data']['authcode'].should_not == nil
end
Then /^the authcode should be associated with '(.*)'$/ do |user|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  hash = JSON.parse(page.body)
  s.mobileauth.should == hash['data']['authcode']
end


