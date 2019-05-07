require 'test_helper'

class CategoryEditTest < ActionDispatch::IntegrationTest
  def setup
		@category = Category.create(name: "Sports", description: "All year round, indoor and outdoor.")
		@category2 = Category.create(name: "Travel", description: "All around the World")
		@admin_user = User.create!(username: "Craig", email: "craig@example.com", password: "password", admin: true)
		@nonadmin_user = User.create!(username: "Fred", email: "fred@example.com", password: "password", admin: false)
	end

	test "admin should update valid category ok" do
		sign_in_as(@admin_user, @admin_user.password)
		get edit_category_path(@category)
		assert_template 'categories/edit'
		my_updated_name = "new_catname"
		my_updated_description = "new cat description"
		patch category_path(@category), params: {category: {name: my_updated_name, description: my_updated_description}}
		# Check there is a flash success message for edit OK
		assert_not flash.empty?
		follow_redirect!
		# Should go to show page after edit OK
		assert_template 'categories/show'
		@category.reload
		assert_match @category.name, my_updated_name
		assert_match @category.description, my_updated_description
	end

	test "reject invalid category update" do
		sign_in_as(@admin_user, @admin_user.password)
		get edit_category_path(@category2)
		assert_template 'categories/edit'
		patch category_path(@category2), params: {category: {name: "", description: "a new description"}}
		# Should stay on edit page
		assert_template 'categories/edit'
		# Make sute there is a h4 message with word error in it
		assert_select 'h4', :text => /error/
	end

	test "reject category edit if not admin user" do
		sign_in_as(@nonadmin_user, @nonadmin_user.password)
		get categories_path
		get edit_category_path(@category2)
		my_updated_name = "new_catname"
		my_updated_description = "new cat description"
		patch category_path(@category2), params: {category: {name: my_updated_name, description: my_updated_description}}
		# Check there is a flash error message for failed
		assert_not flash.empty?
		# Make sure nothing changed!
		@category.reload
		assert_match @category2.name, "Travel" 
		assert_match @category2.description, "All around the World"
	end
end
