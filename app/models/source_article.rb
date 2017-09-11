class SourceArticle < ApplicationRecord
  validates_presence_of :entry_id
  belongs_to :entry
end
