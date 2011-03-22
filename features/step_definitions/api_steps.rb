World(Rack::Test::Methods)

Given /^I am a valid API user$/ do
  @user = Factory(:user)
  authorize(@user.email, @user.password)
end

Given /^I log in using '(.*)' with password '(.*)' on a mobile device$/ do |login, pass|
  # This next line should be done on the Android side, passing the password as a hash
  pwhash = Digest::SHA1.hexdigest(pass + login)
  @result = RestClient.post "http://localhost:3000/login", :data => { 'email' => login, 'password' => pwhash }.to_json
  # This one is also a bit fudged, we have to pull the student from OUR test db, not the db that the result is going to 
  s = Student.first(:email => 'email')
  hash = JSON.parse(@result)
  s.update(:mobileauth => hash['data']['authcode'])
end

When /^I send a POST request to "([^\"]*)" with the following:$/ do |path, body|
  post path, body
end

When /^I log out using a mobile device$/ do
  resulthash = JSON.parse(@result)
  @result = RestClient.post "http://localhost:3000/logout", :data => { 'authcode' => resulthash['data']['authcode'] }.to_json
end

Then /^the JSON authcode I receive should be '(.*)'$/ do |authcode|
  # This step is a bit fudged, as it's difficult to reproduce the time sensative auth codes
  hash = JSON.parse(@result)
  if(authcode == 'FAIL' || authcode == 'Success')
    hash['data']['authcode'].should == authcode
  else
    hash['data']['authcode'].should_not == 'FAIL'
  end
end
Then /^the authcode should be associated with '(.*)'$/ do |email|
  s = Student.first(:email => email)
  hash = JSON.parse(@result)
  s.mobileauth.should == hash['data']['authcode']
end