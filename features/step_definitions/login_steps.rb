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
  # This one is also a bit fudged, we have to pull the student from OUR test db, not the db that the result is going to 
  s = Student.first(:email => 'email')
  hash = JSON.parse(@result)
  s.update(:mobileauth => hash['data']['authcode'])
end

Given /^I am logged in as '(.*)' with password '(.*)'$/ do |email, pass|
    visit("/login")
    fill_in("email", :with => email)
    fill_in("password", :with => pass)
    click_button("Login")
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
Then /^the code should be associated with '(.*)'$/ do |email|
  s = Student.first(:email => email)
  pp "All Users:"
  pp Student.all.count
  hash = JSON.parse(@result)
  pp "Found User:"
  pp s
  pp "Json Provided:"
  pp hash
  s.mobileauth.should == hash['data']['authcode']
end

