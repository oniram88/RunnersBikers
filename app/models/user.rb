# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  api_token              :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  image                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  rank                   :integer
#  total_points           :integer          default(0)
#  username               :string(255)
#

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable #, omniauth_providers: [:strava, :facebook]

  validates :rank, :presence => true, numericality: { greater_than: 0 }
  validates :total_points, :presence => true, numericality: { greater_than_or_equal_to: 0 }
  validates :username, :presence => { allow_blank: false }, uniqueness: true

  after_create :assign_default_role
  before_validation :set_rank

  has_many :performances
  has_many :matches_as_challenger, class_name: 'Match', foreign_key: :challenger_id
  has_many :matches_as_challenged, class_name: 'Match', foreign_key: :challenged_id

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      case auth.provider.to_sym
        when :strava
          user.first_name = auth.info.first_name # assuming the user model has a name
          user.last_name = auth.info.last_name # assuming the user model has a name
          user.image = auth.extra.raw_info.image # assuming the user model has an image
          user.api_token = auth.credentials.token

        when :facebook
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.image = auth.info.image
          user.api_token = auth.credentials.token
        else
          raise auth.inspect
      end

      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      #user.skip_confirmation!
    end
  end

  def update_points
    self.update_attributes(total_points: self.performances.reload.sum(:points))
  end

  def self.update_rank
    counter = 1
    User.order(:total_points => :desc).each do |u|
      u.update_attributes(rank: counter)
      counter += 1
    end
  end

  def open_matches
    matches_as_challenger.wait + matches_as_challenged.wait
  end

  def machable(user)
    return false if user.total_points == 0
    return false if user.id == self.id
    if self.rank - 3 > user.rank or self.rank + 3 < user.rank
      return false
    end
    return false if self.open_matches.length > 0
    return true
  end

  def set_as_judge
    self.add_role(:judge)
  end

  def to_s(format: "%{username}")
    format % self.attributes.deep_symbolize_keys
  end

  private
  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end

  def set_rank
    self.rank = User.count + 1 if self.rank.blank?
  end

end
