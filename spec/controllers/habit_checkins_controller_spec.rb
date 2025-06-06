require 'rails_helper'

RSpec.describe HabitCheckinsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let(:token) { generate_tokens(user).first }
  let!(:habit) { FactoryBot.create(:habit, user: user, created_at: 5.days.ago) }

  before do
    request.headers['Token'] = "Bearer #{token}"
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #all_habit_checkins" do
    let!(:checkin1) { FactoryBot.create(:habit_checkin, habit: habit, date: 3.days.ago.to_date) }
    let!(:checkin2) { FactoryBot.create(:habit_checkin, habit: habit, date: 1.day.ago.to_date) }

    it "returns all checkins ordered by date asc" do
      get :all_habit_checkins, params: { habit_id: habit.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      dates = json['checkins'].map { |c| c['date'] }
      expect(dates).to eq([checkin1.date.to_s, checkin2.date.to_s])
    end
  end

  describe "POST #create_habit_checkins" do
    context "when date param is not given" do
      it "creates a checkin for today" do
        expect {
          post :create_habit_checkins, params: { habit_id: habit.id }
        }.to change(habit.habit_checkins, :count).by(1)
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['checkin']['date']).to eq(Date.today.to_s)
      end
    end

    context "when date param is before habit creation date" do
      it "returns error and does not create checkin" do
        invalid_date = (habit.created_at.to_date - 1.day).to_s
        post :create_habit_checkins, params: { habit_id: habit.id, date: invalid_date }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to include("Cannot mark check-in before the habit was created")
      end
    end

    context "when checkin already exists for date" do
      let!(:existing_checkin) { FactoryBot.create(:habit_checkin, habit: habit, date: Date.today) }

      it "deletes the checkin and returns message" do
        expect {
          post :create_habit_checkins, params: { habit_id: habit.id, date: Date.today.to_s }
        }.to change(habit.habit_checkins, :count).by(-1)
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq("Check-in removed for #{Date.today}")
      end
    end

    context "when checkin does not exist for date" do
      it "creates the checkin and returns it" do
        expect {
          post :create_habit_checkins, params: { habit_id: habit.id, date: (Date.today - 2).to_s }
        }.to change(habit.habit_checkins, :count).by(1)
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['checkin']['date']).to eq((Date.today - 2).to_s)
      end
    end

    context "when checkin save fails" do
      before do
        allow_any_instance_of(HabitCheckin).to receive(:save).and_return(false)
        allow_any_instance_of(HabitCheckin).to receive_message_chain(:errors, :full_messages).and_return(["Some error"])
      end

      it "returns errors with unprocessable_entity status" do
        post :create_habit_checkins, params: { habit_id: habit.id }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Some error")
      end
    end
  end

  private
  def generate_tokens(user)
    token = jwt_encode(user_id: user.id)
    refresh_token = jwt_encode({ user_id: user.id }, 7.days.from_now)
    [token, refresh_token]
  end

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
