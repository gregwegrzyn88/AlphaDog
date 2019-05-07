require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
	def setup
		@category = Category.new(name: "Sports", description: "Sports, such as AFL, Cricket, Hockey")
	end

	test "category should be valid" do
		assert @category.valid?
	end

	test "should reject category with no name" do
		@category.name = ""
		assert_not @category.valid?
	end

	test "should reject category with no description" do
		@category.description = ""
		assert_not @category.valid?
	end

	test "should reject duplicate category" do
		@category.save
		@category2 = Category.new(name: @category.name, description: "another description")
		assert_not @category2.valid?
	end

	test "category name should not be too short" do
		@category.name = "A"
		assert_not @category.valid?
	end

	test "category name should not to too long" do
		@category.name = "A" * 50
		assert_not @category.valid?
	end
end