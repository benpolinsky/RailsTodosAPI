class User < ApplicationRecord
  has_secure_password

  has_many :todos, foreign_key: :created_by
  has_many :user_requests

  validates_presence_of :name, :email, :password_digest

  # A more robust solution would involve ApiRateRules
  # and ApiRateTiers, in which case the below might
  # be moved to a "RequestThrottler" PORO/class

  def over_rapid_request_limit?
    user_requests.where('created_at > ?', DateTime.now - 1.second).size >= 3
  end

  def over_read_request_limit?
    user_requests.where('created_at >= ? AND action = ?', DateTime.now - 1.hour, 1).size >= 40
  end

  def over_write_request_limit?
    user_requests.where('created_at >= ? AND action = ?', DateTime.now - 30.minutes, 2).size >= 25
  end
end
