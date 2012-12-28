# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    game nil
    category nil
    correct_question "MyText"
    answer "MyText"
    amount 1
    start_date "2012-12-27 16:13:29"
  end
end
