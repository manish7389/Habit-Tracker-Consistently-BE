class HabitCheckin < ApplicationRecord
  belongs_to :habit

  validates :date, uniqueness: { scope: :habit_id }

  def self.ransackable_attributes(auth_object = nil)
    %w[id habit_id date created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["habit"]
  end
end
