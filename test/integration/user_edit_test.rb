require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
		@user = User.create!(username: "Craig", email: "craig@example.com", password: "password")
	end

	test "should update valid user ok" do
		sign_in_as(@user, @user.password)		
		get edit_user_path(@user)
		assert_template 'users/edit'
		my_updated_username = "new_username"
		my_updated_email = "new@example.com"
		my_updated_password = "new_password"
		patch user_path(@user), params: {user: {username: my_updated_username, email: my_updated_email, password: my_updated_password}}
		# Check there is a flash success message for edit OK
		assert_not flash.empty?
		@user.reload
		assert_match @user.username, my_updated_username
		assert_match @user.email, my_updated_email
		assert @user.authenticate(my_updated_password) 
	end

	test "should reject invalid user update" do
		sign_in_as(@user, @user.password)
		get edit_user_path(@user)
		patch user_path(@user), params: {user: {username: "", email: "new@example.com.au", password: "new_password"}}
		# Should stay on edit page
		assert_template 'users/edit'
		# Make sute there is a h4 message with word error in it
		assert_select 'h4', :text => /error/
	end

	test "should reject user edit if not logged in" do
		get user_path(@user)
		patch user_path(@user), params: {user: {username: "new_name", email: "new@example.com.au", password: "new_password"}}
		@user.reload
		# Make sure user has not changed
		assert_match @user.username, "Craig"
		assert_match @user.email, "craig@example.com"
	end
end