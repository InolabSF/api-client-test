class Comment < ApplicationRecord
  validates_presence_of :entry_id, :text
  belongs_to :entry #単数形でかく
end
