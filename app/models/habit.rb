class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checkins, dependent: :destroy


  def checkin_dates
    habit_checkins.order(date: :asc).pluck(:date)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name description user_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["habit_checkins", "user"]
  end
end
