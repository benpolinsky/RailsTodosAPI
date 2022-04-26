class Todo < ApplicationRecord
  validates_presence_of :title, :created_by
  has_many :items, dependent: :destroy
  scope :not_done, -> { joins(:items).where('items.done = false') }

  def not_done
    items.where(done: false)
  end
end
