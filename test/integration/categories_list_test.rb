require 'test_helper'

class CategoriesListTest < ActionDispatch::IntegrationTest
	def setup
		@category = Category.create(name: "Sports", description: "All year round, indoor and outdoor.")
		@category2 = Category.create(name: "Travel", description: "All around the World")
		@admin_user = User.create!(username: "Craig", email: "craig@example.com", password: "password", admin: true)
	end

	test "should show list of categories" do
		get categories_path
		assert_template 'categories/index'
		assert_select "a[href=?]", category_path(@category), text: @category.name
		assert_select "a[href=?]", category_path(@category2), text: @category2.name
	end

	test "should have edit option on listing in admin user" do
		sign_in_as(@admin_user, @admin_user.password)
		get categories_path
		assert_template 'categories/index'
		assert_select "a[href=?]", edit_category_path(@category), text: "Edit Category"
	end
  
end