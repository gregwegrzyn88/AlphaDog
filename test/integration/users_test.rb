require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
	def setup
		@user = User.create!(username: "Craig", email: "craig@example4.com", password: "password")
		@article = Article.create!(title: "my title", description: "my description", user: @user)
	end

	test "should create new valid user" do
		get signup_path
		assert_template 'users/new'
		my_new_username = "harry"
		my_new_email = "hpotter@hogwarts.com"
		my_new_password = "ginny"
		# Check if count increases after posting valid new user
		assert_difference 'User.count' do
			post users_path, params: { user: {username: my_new_username, email: my_new_email, password: my_new_password}}
		end
		# Should display a success message
		assert_not flash.empty?
	end

	test "should fail to create invalid user" do
		# Make sure count doesnt increase after posting invalid new user
		assert_no_difference 'User.count' do
			post users_path, params: { user: {username: "", email: "craig@example.com", password: "password"}}
		end

		# Make sure count doesnt increase after posting invalid new user email
		assert_no_difference 'User.count' do
			post users_path, params: { user: {username: "validname", email: "craig.example.com", password: "password"}}
		end

		# Mark sure there is a h4 element with the word error in it
		assert_select 'h4', :text => /error/
	end

	test "should get user show articles page" do
		sign_in_as(@user, @user.password)
		get user_path(@user)
		assert_template 'users/show'
		# Search for links to Articles associated with user
		assert_select "a[href=?]", article_path(@article), text: @article.title
		assert_select "a[href=?]", edit_article_path(@article), text: "Edit this Article"
		assert_match @user.username, response.body
		assert_match @article.description, response.body
	end
end