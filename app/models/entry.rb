class Entry < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_one :feature_image, dependent: :destroy
  belongs_to :user
  has_one :source_article, dependent: :destroy
end
