class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :game_id, :category_id, :answer, :amount, :start_date
end
