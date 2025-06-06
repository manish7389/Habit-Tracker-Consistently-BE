require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'Weekly Summary - every Monday at 9am',
  cron: '0 9 * * 1', #(M, H, d, m, day)
  class: 'WeeklySummaryJob'
)