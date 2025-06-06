require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:habits).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe 'Devise modules' do
    it 'includes default devise modules' do
      expect(User.devise_modules).to include(:database_authenticatable, :registerable, :recoverable, :rememberable, :validatable)
    end
  end

  describe '.ransackable_associations' do
    it 'includes habits' do
      expect(User.ransackable_associations).to include("habits")
    end
  end

  describe '.ransackable_attributes' do
    it 'includes expected attributes' do
      expect(User.ransackable_attributes).to include("email", "first_name", "last_name", "is_active", "created_at", "updated_at")
    end
  end
end
