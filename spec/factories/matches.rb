# == Schema Information
#
# Table name: matches
#
#  id              :integer          not null, primary key
#  challenged_id   :integer
#  challenger_id   :integer
#  status          :integer
#  points          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  challenger_p_id :integer
#  challenged_p_id :integer
#  judge_id        :integer
#

FactoryBot.define do
  factory :match do
    challenged { create(:user_with_points) }
    challenger { create(:user_with_points) }
    points 100


    factory :completed_match do

      after(:create) do |m|
        create(:performance, user: m.challenged)
        create(:performance, user: m.challenger)
        m.reload
      end

    end
  end
end
