class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Extra fields for leader board stuffs.
  attr_writer :overall_score, :first, :second, :third

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

  def self.with_overall_score
    results = User.all
    Game.locked.each do |game|
      scores = self.grouped_and_sorted_by_score(game)

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

  def self.grouped_and_sorted_by_score(game)
    self.all.sort_by do |user|
      -game.score(user)
    end.group_by do |user|
      game.score(user)
    end
  end

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = User.where(:email => data["email"]).first
      user
    else
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end
end
