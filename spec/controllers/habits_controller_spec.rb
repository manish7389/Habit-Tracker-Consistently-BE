require 'rails_helper'

RSpec.describe HabitsController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let(:token) { generate_tokens(user).first }

  let!(:habit) { FactoryBot.create(:habit, user: user, name: "Existing Habit") }

  let(:valid_attributes) do
    {
      name: "New Habit",
      description: "Some description"
    }
  end

  let(:invalid_attributes) do
    {
      name: ""
    }
  end

  before do
    request.headers['Token'] = "Bearer #{token}"
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #all_habits" do
    it "returns all habits for the current user" do
      get :all_habits
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['habits']).to be_an(Array)
      expect(json['habits'].map { |h| h['id'] }).to include(habit.id)
    end
  end

  describe "GET #show_habit" do
    it "returns the requested habit" do
      get :show_habit, params: { id: habit.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['habit']['id']).to eq(habit.id)
    end

    it "raises error when habit not found" do
      expect {
        get :show_habit, params: { id: 0 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST #create_habit" do
    context "with valid params" do
      it "creates a new habit" do
        expect {
          post :create_habit, params: { habit: valid_attributes }
        }.to change(user.habits, :count).by(1)
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['habit']['name']).to eq("New Habit")
        expect(json['message']).to eq('Habit created successful')
      end
    end
  end

  describe "PUT #update_habit" do
    context "with valid params" do
      it "updates the habit" do
        put :update_habit, params: { id: habit.id, habit: { name: "Updated Habit" } }
        expect(response).to have_http_status(:ok)
        habit.reload
        expect(habit.name).to eq("Updated Habit")
      end
    end
    it "raises error when habit not found" do
      expect {
        put :update_habit, params: { id: 0, habit: { name: "Test" } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "DELETE #delete_habit" do
    it "deletes the habit" do
      expect {
        delete :delete_habit, params: { id: habit.id }
      }.to change(user.habits, :count).by(-1)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Habit deleted successful')
    end

    it "raises error when habit not found" do
      expect {
        delete :delete_habit, params: { id: 0 }
      }.to raise_error(ActiveRecord::RecordNotFound)
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
