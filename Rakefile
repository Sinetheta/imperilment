#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

task development_data: :environment do
  users = (0..10).map do
    display_name = [true, false].sample ? FFaker::Name.name : nil
    User.create!(
      email: FFaker::Internet.email,
      display_name: display_name,
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

Imperilment::Application.load_tasks
