class Article < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
end
