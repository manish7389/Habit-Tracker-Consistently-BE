FactoryBot.define do
  factory :habit do
    user
    name { "Exercise" }
    description { "Daily exercise habit" }
    created_at { 10.days.ago }
  end
end