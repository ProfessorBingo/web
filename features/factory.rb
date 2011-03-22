require 'factory_girl'
Factory.define :user, :class => Student do |u|
  u.email "eric@school.edu"
  u.first_name "Eric"
  u.last_name "Stokes"
  u.password "password"
end