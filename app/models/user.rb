class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

  # Extra fields for leader board stuffs.
  attr_writer :overall_score, :first, :second, :third

  has_many :game_results, dependent: :destroy
  has_many :questions, dependent: :destroy

  def identifier
    display_name.presence || 'Anonymous'
  end

  def self.find_for_google_oauth2(access_token, _signed_in_resource = nil)
    data = access_token.info
    User.where(email: data["email"]).first_or_create! do |user|
      user.email = data["email"]
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def pending_answers
    # Answers from unlocked games with no matching question
    answer = Answer.arel_table
    question = Question.arel_table
    question_join = answer.
                    join(question, Arel::Nodes::OuterJoin).
                    on(question[:answer_id].eq(answer[:id]).and(question[:user_id].eq(id)))
    Answer.
      joins(question_join.join_sources).
      joins(:game).
      where(games: { locked: false }).
      where(questions: { id: nil }).
      order(:start_date)
  end

  def correct_ratio(season = nil)
    season ||= Season.current
    total = questions.where(created_at: season.date_range).count.to_f
    correct = questions.where(created_at: season.date_range).correct.count

    if total > 0
      correct / total
    else
      0.0
    end
  end
end
