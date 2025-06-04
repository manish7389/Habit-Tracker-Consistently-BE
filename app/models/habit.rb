class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checkins, dependent: :destroy


  def checkin_dates
    habit_checkins.order(date: :asc).pluck(:date)
  end
end
