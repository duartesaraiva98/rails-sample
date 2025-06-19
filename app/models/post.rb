class Post < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :title, presence: true, length: { minimum: 2 }
  validates :content, presence: true, length: { minimum: 10 }
end
