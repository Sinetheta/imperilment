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

  # Wish there was a nicer way to do this. >.<
  def overall_score; @overall_score ||= 0; end
  def first; @first ||= 0; end
  def second; @second ||= 0; end
  def third; @third ||= 0; end

  def increment_rank(rank)
    case rank
    when 0
      self.first += 1
    when 1
      self.second += 1
    when 2
      self.third += 1
    end
  end

  def identifier
    full_name.blank? ? email : full_name
  end

  def full_name
    [first_name, last_name].reject {|n| n.blank?}.join ' '
  end

  def self.with_overall_score
    results = User.all
    Game.locked.each do |game|
      scores = game.grouped_and_sorted_by_score

      scores.each_with_index do |(score, users), idx|
        users.each do |user|
          result = results.find{|u| u == user}
          result.overall_score += score
          result.increment_rank(idx)
        end
      end
    end

    results.sort_by do |user|
      [-user.first, -user.second, -user.third, -user.overall_score]
    end.group_by do |user|
      user.overall_score
    end
  end

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where(email: data["email"]).first
      # TODO: Once all current users have last_name, we can pull this out.
      if user.last_name.blank?
        user.last_name = data["last_name"].try(:first)
        user.save!
      end
      user
    else
      User.create!(
        email: data["email"],
        first_name: data["first_name"],
        last_name: data["last_name"].try(:first),
        password: Devise.friendly_token[0,20]
      )
    end
      #stubbing methods from the class under test===bad
  end

  def percentage_correct_overall
    ((questions.correct.count.to_f / questions.count.to_f)*100)
  end

end
