require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
		@user = User.create!(username: "Craig", email: "craig@example3.com", password: "password")
		@admin = User.create!(username: "Admin", email: "admin@example.com", password: "password", admin: true)
		@article = Article.create!(title: "my title", description: "my description", user: @user)
	end

	test "reject invalid login attempt" do
		get login_path
		assert_template 'sessions/new'
		post login_path, params: { session: { email: "admin@example.com", password: "invalid_password"} }
		assert_template 'sessions/new'
		# Should get a fail message
		assert_not flash.empty?
		# Check there is still a login link
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", logout_path, count: 0
	end

	test "accept valid login and start session" do
		get login_path
		assert_template 'sessions/new'
		post login_path, params: { session: { email: "craig@example3.com", password: "password"} }
		follow_redirect!
		assert_template 'users/show'
		# On login there should now be a logout option, and no login option
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", login_path, count: 0
	end
end