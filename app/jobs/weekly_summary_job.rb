class WeeklySummaryJob < ApplicationJob
  queue_as :default

  def perform(*args)
    User.find_each do |user|
      WeeklySummaryMailer.summary_email(user).deliver_later
    end
  end
end
