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
#

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable #, omniauth_providers: [:strava, :facebook]

  after_create :assign_default_role


  has_many :performances



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
          user.first_name= auth.info.first_name
          user.last_name=auth.info.last_name
          user.image=auth.info.image
          user.api_token=auth.credentials.token
        else
          raise auth.inspect
      end

      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      #user.skip_confirmation!
    end
  end

  private
  def assign_default_role
    self.add_role(:newuser) if self.roles.blank?
  end

end
