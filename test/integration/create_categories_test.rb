require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  def setup
		@category = Category.new(name: "Sports", description: "Sports, such as AFL, Cricket, Hockey")
		@admin_user = User.create!(username: "Craig", email: "craig@example.com", password: "password", admin: true)
	end

	test "should get new category form and create valid category" do
		sign_in_as(@admin_user, @admin_user.password)
		get new_category_path
		assert_template 'categories/new'
		assert_difference "Category.count", 1 do
			post categories_path, params: { category: {name: "Cooking", description: "All things meal related"} }
		end
		follow_redirect!
		assert_template 'categories/index'
		assert_match "Cooking", response.body
	end

	test "should reject creating an invalid category" do
		sign_in_as(@admin_user, @admin_user.password)
		get new_category_path
		assert_template 'categories/new'
		assert_no_difference "Category.count" do
			post categories_path, params: { category: {name: "", description: "Bad category!"} }
		end
		assert_template 'categories/new'
		# Mark sure there is a h4 element with the word error in it
		assert_select 'h4', :text => /error/
	end

	test "should reject creating an duplicate category" do
		sign_in_as(@admin_user, @admin_user.password)
		@category.save
		get new_category_path
		assert_template 'categories/new'
		assert_no_difference "Category.count" do
			post categories_path, params: { category: {name: "Sports", description: "Same Category!"} }
		end
		assert_template 'categories/new'
		# Mark sure there is a h4 element with the word error in it
		assert_select 'h4', :text => /error/
	end
end