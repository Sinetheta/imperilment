class GameSerializer < ActiveModel::Serializer
  attributes :id, :locked, :created_at, :ended_at
end
