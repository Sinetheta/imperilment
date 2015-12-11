#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

task development_data: :environment do
  admin = User.new(email: 'admin@example.com', password: 'test123')
  admin.save!(validate: false)
  admin.add_role :admin

  users = (0..10).map do
    first_name = FFaker::Name.first_name
    last_name = FFaker::Name.last_name
    User.create!(
      email: FFaker::Internet.email("#{first_name} #{last_name}"),
      first_name: first_name,
      last_name:  last_name,
      password: 'asdfg12345'
    )
  end

  category = Category.create!(name: 'Potpourri')
  date = 1.months.ago.beginning_of_week
  while date <= Time.current
    game = Game.create!(created_at: date, ended_at: date + 6.days)
    7.times do |_i|
      answer = game.answers.create!(category: category, amount: [200, 400, 800].sample, answer: 'Answer', correct_question: 'Correct Question', start_date: date, created_at: date)
      users.each do |user|
        answer.questions.create!(user: user, correct: [true, false].sample)
      end
      date += 1.day
    end
    game.update(locked: true)
  end
end

Oops::Tasks.new do |oops|
  oops.includes += Dir['.env*']
end

Imperilment::Application.load_tasks
