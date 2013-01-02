# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    game
    category
    correct_question "What is a test?"
    answer "This type of code is used to ensure correct behaviour."
    amount 100
    start_date "2012-12-27 16:13:29"
  end
end
