# == Schema Information
#
# Table name: matches
#
#  id            :integer          not null, primary key
#  challenged_id :integer
#  challenger_id :integer
#  status        :integer
#  points        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :match do
    challenged { create(:user) }
    challenger { create(:user) }
    points 100
  end
end
