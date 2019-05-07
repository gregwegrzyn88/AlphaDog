require 'test_helper'

class ArticleEditTest < ActionDispatch::IntegrationTest
  def setup
		@user = User.create!(username: "Craig", email: "craig@example.com", password: "password")
		@article = Article.create!(title: "my title", description: "my description", user: @user)
	end

	test "should update valid article ok" do
		sign_in_as(@user, @user.password)
		get article_path(@article)
		assert_template 'articles/show'
		# Check for Edit button link
		assert_select 'a[href=?]', edit_article_path(@article), text: "Edit this Article"

		get edit_article_path(@article)
		updated_article_title = "my updated title"
		updated_article_description = "my updated description"
		patch article_path(@article), params: {article: {title: updated_article_title, description: updated_article_description}}
		assert_redirected_to @article
		# Check there is a flash success message for edit OK
		assert_not flash.empty?
		@article.reload
		assert_match @article.title, updated_article_title
		assert_match @article.description, updated_article_description
	end

	test "should reject update of invalid article" do
		sign_in_as(@user, @user.password)
		get edit_article_path(@article)
		# Try to update title with BLANK 
		patch article_path(@article), params: {article: {title: "", description: "this is ok - but title is not!"}}
		# Should stay on edit page
		assert_template 'articles/edit'
		# Make sure there is a h4 message with word error in it
		assert_select 'h4', :text => /error/
	end
end