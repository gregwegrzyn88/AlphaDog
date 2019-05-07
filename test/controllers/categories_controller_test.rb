require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
	def setup
		@category = Category.create(name: "Sports", description: "Sports, such as AFL, Cricket, Hockey")
		@admin_user = User.create!(username: "Craig", email: "craig@example.com", password: "password", admin: true)
	end

	test "should get categories index list" do
		get categories_path
		assert_response :success
	end

	test "should get new category" do
		sign_in_as(@admin_user, @admin_user.password)
		get new_category_path
		assert_response :success
	end

	test "should get show category" do
		get category_path(@category)
		assert_response :success
	end

	test "should reject create category if not admin user" do
		assert_no_difference 'Category.count' do
			post categories_path, params: { category: {name: "Cooking", description: "All things meal related"} }
		end
		follow_redirect!
		assert_template 'categories/index'
  end
end