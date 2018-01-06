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
#  points        :decimal(15, 3)
#

FactoryBot.define do
  factory :performance do


    user
    distance { Faker::Number.decimal(2, 2) }
    pace "4:10"
    positive_gain { Faker::Number.number(3) }
    url { Faker::Internet.unique.url }

    factory :performance_with_points do
      transient do
        points_set 1000
      end

      after(:create) do |p, evaluator|
        p.update_attribute(:points, evaluator.points_set)
      end

    end

  end
end
