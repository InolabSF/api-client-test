class FeatureImage < ApplicationRecord
  validates_presence_of :url
  mount_uploader :url, FeatureImageUploader
  belongs_to :entry
end
