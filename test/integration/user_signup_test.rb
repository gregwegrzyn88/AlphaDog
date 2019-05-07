require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "should get user signup path" do
  	get signup_path
  	assert_response :success
  end

  test "reject an invalid signup" do
  	get signup_path
  	assert_template 'users/new'
  	# Make sure count does not increase when trying to create invalid user
  	assert_no_difference 'User.count' do
  		post users_path, params: { user: {username: " ", email: "test@example.com", password: "password" } }
  	end
  	assert_template 'users/new'
  	assert_select "h4.alert-heading"
  end

  test "accept and create valid new user" do
  	get signup_path
  	assert_template 'users/new'
  	# Make sure count increases when a valid user is signed up
  	assert_difference 'User.count' do
  		post users_path, params: { user: {username: "NewUser", email: "newuser@example.com", password: "password" } }
  	end
  	# Should go to the User Show page after signup
  	follow_redirect!
  	assert_template 'users/show'
  	# Should have flash success message
  	assert_not flash.empty?
  end
end