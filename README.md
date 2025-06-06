# README

Habit Tracker API
  A Rails 7 API application for tracking personal habits, enabling users to create habits and mark daily check-ins. Built with PostgreSQL, Sidekiq, Redis, Devise, JWT, and tested with RSpec.

Project Overview
  This API-only Rails application allows authenticated users to manage habits and mark daily habit check-ins. It uses:

  * Devise + JWT for secure authentication
  * PostgreSQL for data persistence
  * Sidekiq + Redis for background job processing and scheduling
  * ActiveModelSerializers for clean JSON API responses
  * RSpec for automated testing

System Requirements & Versions
  * Ruby: 3.3.0
  * Rails: 7.1.5.1
  * PostgreSQL: >= 12.x
  * Redis
  * Sidekiq: 6.5.8
  * Devise: latest compatible with Rails 7
  * Other gems: see Gemfile

Setup & Installation
  1. Clone the repository
    git clone <repository-url>
    cd habit-tracker-api
  2. Install dependencies
    gem install bundler or bundle install
  3. Setup PostgreSQL database
    rails db:create
    rails db:migrate
  4. Configure environment variables
    cp .env.example .env
    HOST=http://localhost:3000
    EMAIL_USERNAME=email
    EMAIL_PASSWORD=password

  Database Setup
    rails db:migrate

Starting the Application
  1. Start Redis Server
    redis-server
  2. Start Sidekiq Worker
    bundle exec sidekiq
  3. Start Rails Server
    rails s
Running Tests
  bundle exec rspec

API Endpoints
  HabitsController
    Method	Path	Description
    GET	/habits	List all habits for current user
    GET	/habits/:id	Show a specific habit
    POST	/habits	Create a new habit
    PUT	/habits/:id	Update a habit
    DELETE	/habits/:id	Delete a habit

  HabitCheckinsController
    Method	Path	Description
    GET	/habits/:habit_id/checkins	List all check-ins for a habit
    POST	/habits/:habit_id/checkins	Toggle (create/delete) a check-in for a date

Background Jobs & Mailers
  * Sidekiq handles asynchronous tasks such as sending emails or scheduled jobs.
  * Redis is used as the backend for Sidekiq.
  * Emails to users (e.g., notifications) are delivered via ActionMailer.
  * Configure SMTP settings in your environment variables.

Serializers
  * JSON responses are formatted with ActiveModelSerializers for:
  * User
  * Habit
  * HabitCheckin
  * This provides clean and consistent API responses.

Contact
  * For questions, please contact:

Your Name
  * Email: Manish.ahir071997@gmail.com

