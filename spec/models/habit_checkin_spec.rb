require 'rails_helper'

RSpec.describe HabitCheckin, type: :model do
  describe "associations" do
    it { should belong_to(:habit) }
  end

  describe ".ransackable_attributes" do
    it "returns correct ransackable attributes" do
      expect(HabitCheckin.ransackable_attributes).to match_array(
        %w[id habit_id date created_at updated_at]
      )
    end
  end

  describe ".ransackable_associations" do
    it "returns correct ransackable associations" do
      expect(HabitCheckin.ransackable_associations).to eq(["habit"])
    end
  end
end
