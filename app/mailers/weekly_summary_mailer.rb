class WeeklySummaryMailer < ApplicationMailer
  def summary_email(user)
    @user = user
    @habits = user.habits.includes(:habit_checkins)
    mail(to: @user.email, subject: 'Your Weekly Habit Summary')
  end
end
