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
    challenged_id 1
    challenger_id 1
    status 1
    points 1
  end
end
