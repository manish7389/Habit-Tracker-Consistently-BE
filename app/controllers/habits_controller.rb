class HabitsController < ApplicationController
  before_action :set_habit, only: [:show_habit, :update_habit, :delete_habit]
  
  def all_habits
    habits = current_user.habits.includes(:habit_checkins)
    render json: {habits: ActiveModelSerializers::SerializableResource.new(habits, each_serializer: HabitSerializer) }, status: :ok
  end

  def show_habit
    render json: {habit: ActiveModelSerializers::SerializableResource.new(@habit, each_serializer: HabitSerializer) }, status: :ok
  end

  def update_habit
    if @habit.update(habit_params)
      render json: {habit: ActiveModelSerializers::SerializableResource.new(@habit, each_serializer: HabitSerializer) }, status: :ok
    else
      render json: { errors: @habit.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_habit
    habit = current_user.habits.build(habit_params)
    if habit.save
      render json: {habit: ActiveModelSerializers::SerializableResource.new(habit, each_serializer: HabitSerializer), message: 'Habit created successful' }, status: :created
    else
      render json: { errors: habit.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete_habit
    @habit.destroy
    render json: {message: 'Habit deleted successful'}, status: :ok
  end

  private

  def set_habit
    @habit = current_user.habits.find(params[:id])
  end

  def habit_params
    params.require(:habit).permit(:name, :description)
  end

end
