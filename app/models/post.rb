class Post < ApplicationRecord
  validates :author, presence: true
  validates :title, presence: true
  validates :content, presence: true
end
