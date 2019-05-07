require 'test_helper'

class ArticleDeleteTest < ActionDispatch::IntegrationTest
  def setup
		@user = User.create!(username: "Craig", email: "craig@example.com", password: "password")
		@user2 = User.create!(username: "Fred", email: "fred@example.com", password: "password")
		@admin = User.create!(username: "Admin", email: "admin@example.com", password: "password", admin: true)
		@article = Article.create!(title: "my title", description: "my description", user: @user)
	end

	test "should delete article ok" do
		sign_in_as(@user, @user.password)
		get article_path(@article)
		assert_select 'a[href=?]', article_path(@article), text: "Delete this Article"
		# Check if the count decreases on successful delete
		assert_difference 'Article.count', -1 do
			delete article_path(@article)
		end
		# Should flash a success message
		assert_not flash.empty?
	end

	test "should disallow delete if not correct user" do
		sign_in_as(@user2, @user2.password)
		get article_path(@article)
		# Check if the count is the same - reject delete
		assert_no_difference 'Article.count' do
			delete article_path(@article)
		end
	end

	test "should allow admin user to delete article" do
		sign_in_as(@admin, @admin.password)
		get article_path(@article)
		assert_select 'a[href=?]', article_path(@article), text: "Delete this Article"
		# Check if the count decreases on successful delete
		assert_difference 'Article.count', -1 do
			delete article_path(@article)
		end
		# Should flash a success message
		assert_not flash.empty?
	end
end

