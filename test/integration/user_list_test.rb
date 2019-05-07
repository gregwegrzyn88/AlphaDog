require 'test_helper'
#require 'database_cleaner'

class UserListTest < ActionDispatch::IntegrationTest
  def setup
#logger = Logger.new('logfile.log')
#logger.debug("SETUP User List Test - User Count =#{User.count}")
		@user = User.create!(username: "Craig", email: "craig@example3.com", password: "password")
		@admin = User.create!(username: "Admin", email: "admin@example.com", password: "password", admin: true)
		@article = Article.create!(title: "my title", description: "my description", user: @user)
	end

	test "should get list of users" do
# Not sure why this is failing - thought it was because article create was hardcoded user? Need to come back here!	
#logger = Logger.new('logfile.log')
#logger.debug("User List Test - User Count =#{User.count}")
#@allusers = User.all
#@allusers.each do |user|
#logger.debug("User ID: #{user.id}, User Username: #{user.username}")
#end
		get users_path
		assert_template 'users/index'
		assert_select "a[href=?]", user_path(@user), text: @user.username
		assert_match "1 article", response.body
	end

	test "should allow admin user to delete user" do
		sign_in_as(@admin, @admin.password)
		get users_path
		assert_template 'users/index'
		assert_select "a[href=?]", user_path(@user), text: "Delete this User"
		# Check if the count decreases on successful delete
		assert_difference 'User.count', -1 do
			delete user_path(@user)
		end
		# Should flash a success message
		assert_not flash.empty?
	end

	test "should disallow non-admin user to delete user" do
		sign_in_as(@user, @user.password)
		get users_path
		assert_template 'users/index'
		assert_select "a[href=?]", user_path(@admin), text: @admin.username
		# Check if the count does NOT delete
		assert_no_difference 'User.count' do
			delete user_path(@admin)
		end
	end
end