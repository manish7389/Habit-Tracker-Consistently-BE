class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_checkins, dependent: :destroy


  def checkin_dates
    habit_checkins.order(date: :asc).pluck(:date)
  end

  def total_completions
    habit_checkins.count
  end

  def total_days
    (Date.today - created_at.to_date).to_i + 1
  end

  def done_days_count
    habit_checkins.count
  end

  def consistency_percentage
    return 0 if total_days <= 0
    (done_days_count.to_f / total_days * 100).round(2)
  end

  def current_streak
    return 0 if habit_checkins.empty?

    streak = 0
    day = Date.today

    while habit_checkins.exists?(date: day)
      streak += 1
      day = day - 1.day
    end

    streak
  end

  def longest_streak
    return 0 if habit_checkins.empty?

    dates = habit_checkins.order(:date).pluck(:date)

    longest_streak = 1
    current_streak = 1

    dates.each_cons(2) do |d1, d2|
      if (d2 - d1).to_i == 1
        current_streak += 1
        longest_streak = [longest_streak, current_streak].max
      else
        current_streak = 1
      end
    end

    longest_streak
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name description user_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["habit_checkins", "user"]
  end
end
