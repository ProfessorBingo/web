Given /^A user '(.*)' with password '(.*)' exists$/ do |email, pass|
  s = Student.first_or_new
  s.first_name='First'
  s.last_name='First'
  s.email=email
  s.password=pass
  s.save
end

Given /^I log in using '(.*)' with password '(.*)' on a mobile device$/ do |login, pass|
  # This next line should be done on the Android side, passing the password as a hash
  pwhash = Digest::SHA1.hexdigest(pass + login)
  @result = RestClient.post "http://localhost:3000/login", :data => { 'email' => login, 'password' => pwhash }.to_json
end

Then /^the JSON authcode I recieve should be '\{"([^"]*)":\{"([^"]*)":"([^"]*)"\}\}'$/ do |data, authcode_key, authcode_value|
  # This step is a bit fudged, as it's difficult to reproduce the time sensative auth codes
  hash = JSON.parse(@result)
  hash['data']['authcode'].should_not == 'FAIL'
end