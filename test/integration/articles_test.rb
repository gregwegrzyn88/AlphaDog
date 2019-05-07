require 'test_helper'

class ArticlesTest < ActionDispatch::IntegrationTest
  	def setup
#logger = Logger.new('logfile.log')
#logger.debug("Start Setup User Count is: #{User.count}")
		@user = User.create!(username: "Craig", email: "craig@example2.com", password: "password")
		@article = Article.create!(title: "my title", description: "my description", user: @user)
		@category = Category.create(name: "Sports", description: "All year round, indoor and outdoor.")
		@category2 = Category.create(name: "Travel", description: "All around the World")
		ArticleCategory.create(article: @article, category: @category)
		ArticleCategory.create(article: @article, category: @category2)
#logger.debug("End Setup User Count is: #{User.count}")
#logger.debug("End Setup Article Count is: #{Article.count}")
	end

	test "should get articles listing" do
		get articles_path
		assert_response :success
		assert_template 'articles/index'
		# Mark sure we can find the article in the listing
		assert_select "div", text: @article.title
		assert_select "div", text: @article.description
	end

	test "should display category links associated with article on listing" do
		get articles_path
		assert_response :success
		assert_template 'articles/index'
		assert_select "a[href=?]", category_path(@category), text: @category.name
		assert_select "a[href=?]", category_path(@category2), text: @category2.name
	end

	test "should show an article" do
		sign_in_as(@user, @user.password)
		get article_path(@article)
		assert_template 'articles/show'

		assert_match @article.title, response.body
		assert_match @article.description, response.body

		assert_select 'a[href=?]', edit_article_path(@article), text: "Edit this Article"
		assert_select 'a[href=?]', articles_path, text: "Return to Article Listing"
	end

	test "should display category links associated with article on show page" do
		sign_in_as(@user, @user.password)
		get article_path(@article)
		assert_template 'articles/show'
		assert_select "a[href=?]", category_path(@category), text: @category.name
		assert_select "a[href=?]", category_path(@category2), text: @category2.name
	end

	test "should create new valid article" do
#logger = Logger.new('logfile.log')
		sign_in_as(@user, @user.password)
		get new_article_path
		assert_template 'articles/new'
		my_article_title = "new article title"
		my_article_description = "new article description"
#logger.debug "User email is: #{@user.email}"
		# Check if count increases after posting valid new article
		assert_difference 'Article.count' do
			post articles_path, params: { article: {title: my_article_title, description: my_article_description, user: @user}}
		end
		# Should display a success message
		assert_not flash.empty?
		@myarticle = Article.first

		# After successful post should go to show page
		follow_redirect!
		assert_match my_article_title, response.body
		assert_match my_article_description, response.body
	end

	test "should reject new invalid article" do
		sign_in_as(@user, @user.password)
		get new_article_path
		assert_template 'articles/new'
		my_article_title = "new valid article title"
		my_article_description = ""
		# Make sure count does not increase after posting invalid new article
		assert_no_difference 'Article.count' do
			post articles_path, params: { article: {title: my_article_title, description: my_article_description, user: @user}}
		end
		assert_template 'articles/new'
		# Make sure there is a h4 element and it has the word error in its content
		assert_select 'h4', :text => /error/
	end

end