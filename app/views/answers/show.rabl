attributes :id,
           :game_id,
           :amount,
           :answer,
           :start_date,
           :created_at,
           :updated_at

node(:url) { |answer| game_answer_url answer.game, answer }

child :category do
  attributes :id, :name
end
