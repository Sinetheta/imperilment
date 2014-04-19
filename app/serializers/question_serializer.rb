class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :answer_id, :user_id, :response, :amount
end
