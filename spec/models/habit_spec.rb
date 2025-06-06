require 'rails_helper'

RSpec.describe Habit, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:habit_checkins).dependent(:destroy) }
  end

  describe '.ransackable_attributes' do
    it 'includes expected attributes' do
      expect(Habit.ransackable_attributes).to include("name", "description", "user_id", "created_at", "updated_at")
    end
  end

  describe '.ransackable_associations' do
    it 'includes expected associations' do
      expect(Habit.ransackable_associations).to include("habit_checkins", "user")
    end
  end
end
