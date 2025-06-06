class HabitSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :current_streak, :longest_streak, :consistency_percentage, :total_completions, :checkin_dates

  def current_streak
    object.current_streak
  end

  def longest_streak
    object.longest_streak
  end

  def consistency_percentage
    object.consistency_percentage
  end

  def total_completions
    object.total_completions
  end

  def checkin_dates
    object.habit_checkins.pluck(:date).sort
  end
end