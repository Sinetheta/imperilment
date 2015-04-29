attributes :id,
           :created_at,
           :updated_at

child(:answer, partial: 'answers/show')

node(:user) { |question| question.user.email }
