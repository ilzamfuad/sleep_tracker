FactoryBot.define do
  factory :follow do
    id { 1 }
    association :follower, factory: :user
    association :follower, factory: :user
    is_followed { true }
  end
end
