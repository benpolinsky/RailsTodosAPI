# An user's api request
# A better name is ApiRequst
class UserRequest < ApplicationRecord
  validates_presence_of :action
  belongs_to :user
end
