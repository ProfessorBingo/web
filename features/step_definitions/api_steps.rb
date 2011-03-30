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

# Must run this one as rack_test!!!
Given /^I log in as '(.*)' via JSON with null values$/ do |user|
  Capybara.current_driver = :rack_test
  u = Factory.build(user.to_sym)
  json_login = {'email' => 'null', 'password' => ''}.to_json
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
  rack_test_session_wrapper.process :post, '/logout' ,:data => json_logout
end

# Must run this one as rack_test!!!
When /^I ask for status as '(.*)' via JSON$/ do |user|
  Capybara.current_driver = :rack_test
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  json_logout = {'authcode' => s.mobileauth, 'action' => 'status'}.to_json
  rack_test_session_wrapper = Capybara.current_session.driver
  rack_test_session_wrapper.process :post, '/status' ,:data => json_logout
end

Then /^the JSON '(.*)' I receive should be '(.*)'$/ do |key, value|
  jsonresult = JSON.parse(page.body)
  jsonresult['data'][key].should == value
end

Then /^the JSON '(.*)' I receive should not be '(.*)'$/ do |key, value|
  jsonresult = JSON.parse(page.body)
  jsonresult['data'][key].should_not == value
  jsonresult['data'][key].should_not == ''
  jsonresult['data'][key].should_not == nil
end

Then /^the '(.*)' should be associated with '(.*)'$/ do |key, user|
  attrs = Factory.attributes_for(user.to_sym)
  s = Student.first(:email => attrs[:email])
  hash = JSON.parse(page.body)
  s.mobileauth.should == hash['data'][key]
end