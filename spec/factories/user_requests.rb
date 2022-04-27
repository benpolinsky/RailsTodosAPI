FactoryBot.define do
  factory :user_request do
    user { nil }
    action { 0 }
    requested_on { DateTime.now }
  end
end
