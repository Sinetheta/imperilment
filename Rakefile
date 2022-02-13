#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

task development_data: :environment do
  puts 'Generating users'
  users = (0..10).map do
    display_name = [true, false].sample ? FFaker::Name.name : nil
    User.create!(
      email: FFaker::Internet.email,
      display_name: display_name,
      password: 'asdfg12345'
    ).tap do
      print '.'
    end
  end
  puts

  category = Category.create!(name: 'Potpourri')
  date = 1.months.ago.beginning_of_week
  puts 'Generating games'
  while date <= Time.current
    game = Game.create!(created_at: date, ended_at: date.end_of_week)
    7.times do |_i|
      answer = game.answers.create!(category: category, amount: game.next_answer_amount, answer: 'Answer', correct_question: 'Correct Question', start_date: game.next_answer_start_date, created_at: date)
      users.each do |user|
        answer.questions.create!(user: user, correct: [true, false, nil].sample) do |q|
          q.amount = 0 if answer.final?
        end
      end
      date += 1.day
    end
    game.update(locked: true)
    print '.'
  end
  puts
end

Imperilment::Application.load_tasks
