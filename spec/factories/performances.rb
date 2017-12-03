# == Schema Information
#
# Table name: performances
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  distance      :decimal(8, 4)
#  pace          :integer
#  positive_gain :integer
#  url           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  points        :integer
#

FactoryBot.define do
  factory :performance do


    user
    distance { Faker::Number.decimal(2, 2)}
    pace "4:10"
    positive_gain { Faker::Number.number(3) }
    url { Faker::Internet.unique.url }

  end
end
