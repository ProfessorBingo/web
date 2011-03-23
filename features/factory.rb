require 'factory_girl'
Factory.define :user, :class => Student do |u|
  u.email "eric@school.edu"
  u.first_name "Eric"
  u.last_name "Stokes"
  u.password "password"
end

Factory.define :user_two, :class => Student do |u|
  u.email "user_2@school.edu"
  u.first_name "User"
  u.last_name "Two"
  u.password "password"
end

Factory.define :admin, :class => Student do |u|
  u.email "admin@school.edu"
  u.first_name "Admin"
  u.last_name "istrator"
  u.password "password"
  u.permissions "admin"
end

Factory.define :mod, :class => Student do |u|
  u.email "mod@school.edu"
  u.first_name "Mod"
  u.last_name "erator"
  u.password "password"
  u.permissions "mod"
end