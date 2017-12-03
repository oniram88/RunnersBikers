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
#  rank                   :float(24)
#  total_points           :integer          default(0)
#

FactoryBot.define do
  factory :user do

    email { Faker::Internet.unique.email }

    after(:build) { |u| u.password_confirmation = u.password = Faker::Number.number(10) }

  end
end
