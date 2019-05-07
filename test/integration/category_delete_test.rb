require 'test_helper'

class CategoryDeleteTest < ActionDispatch::IntegrationTest
	def setup
		@category = Category.create(name: "Sports", description: "All year round, indoor and outdoor.")
		@category2 = Category.create(name: "Travel", description: "All around the World")
		@admin_user = User.create!(username: "Craig", email: "craig@example.com", password: "password", admin: true)
		@nonadmin_user = User.create!(username: "Fred", email: "fred@example.com", password: "password", admin: false)
	end

  test "should allow category delete for admin user" do
  	sign_in_as(@admin_user, @admin_user.password)
		get category_path(@category)
		assert_template 'categories/show'
		assert_select "a[href=?]", category_path(@category), text: "Delete Category"
		# Check if the count decreases on successful delete
		assert_difference 'Category.count', -1 do
			delete category_path(@category)
		end
		# Should flash a success message
		assert_not flash.empty?
  end

  test "should disallow category delete for non admin user" do
  	sign_in_as(@nonadmin_user, @nonadmin_user.password)
		get category_path(@category)
		assert_template 'categories/show'
		# Count should NOT decrease on delete
		assert_no_difference 'Category.count' do
			delete category_path(@category)
		end
		# SHould be redirected to categories listing
		follow_redirect!
		assert_template 'categories/index'
  end
end
