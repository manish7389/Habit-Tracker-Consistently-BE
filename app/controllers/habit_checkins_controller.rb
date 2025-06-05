class HabitCheckinsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit

  def index 
    checkins = @habit.habit_checkins.order(date: :asc)
    render json: checkins, each_serializer: HabitCheckinSerializer
  end

  def create
    date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    checkin = @habit.habit_checkins.find_or_initialize_by(date: date)

    if checkin.persisted?
      render json: { message: "Already marked as done for #{date}" }, status: :ok
    elsif checkin.save
      render json: checkin, serializer: HabitCheckinSerializer, status: :created
    else
      render json: { errors: checkin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id])
  end
end
