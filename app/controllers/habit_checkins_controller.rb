class HabitCheckinsController < ApplicationController
  before_action :set_habit

  def all_habit_checkins 
    checkins = @habit.habit_checkins.order(date: :asc)
    render json: {checkins: ActiveModelSerializers::SerializableResource.new(checkins, each_serializer: HabitCheckinSerializer) }, status: :ok
  end

  def create_habit_checkins
    date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    if date < @habit.created_at.to_date
      return render json: { error: "Cannot mark check-in before the habit was created on #{@habit.created_at.to_date}" },
             status: :unprocessable_entity
    end
    checkin = @habit.habit_checkins.find_or_initialize_by(date: date)

    if checkin.persisted?
      checkin.destroy
      render json: { message: "Check-in removed for #{date}" }, status: :ok
    elsif checkin.save
      render json: {checkin: ActiveModelSerializers::SerializableResource.new(checkin, each_serializer: HabitCheckinSerializer) }, status: :created
    else
      render json: { errors: checkin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:habit_id])
  end
end
