# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    game
    category
    correct_question "What is a test?"
    answer "This type of code is used to ensure correct behaviour."
    amount 100
    sequence(:start_date) { |n| Date.new(2013,1,1) + n.days }
  end
end
