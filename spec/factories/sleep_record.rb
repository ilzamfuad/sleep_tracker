FactoryBot.define do
  factory :sleep_record do
    association :user, factory: :user
    sleep_time { "2021-08-01 22:00:00" }
    wake_time { "2021-08-02 06:00:00" }
    duration { 8 }
    status { "inactive" }
  end
end
