class Item < ApplicationRecord
  validates_presence_of :name
  belongs_to :todo
  
  scope :done, -> { where(done: true) }
end
