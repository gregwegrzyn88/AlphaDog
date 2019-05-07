class Article < ApplicationRecord
	belongs_to :user
	has_many :article_categories, dependent: :destroy
	has_many :categories, through: :article_categories
	validates :title, presence: true, length: { minimum: 3, maximum: 50 }
	validates :description, presence: true, length: { minimum: 5, maximum: 400 }
	validates :user_id, presence: true
end