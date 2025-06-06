FactoryBot.define do
  factory :habit_checkin do
    habit
    date { Date.today }
  end
end