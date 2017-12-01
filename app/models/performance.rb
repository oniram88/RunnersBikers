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
#

require 'pace_type'

class Performance < ApplicationRecord

  belongs_to :user

  attribute :pace, :pace, default: '00:00'

  validates :distance, presence: true, numericality: { greater_than: 0,less_than_or_equal_to: 9999.9999 }
  validates :pace, presence: true, format: PaceType.reg_exp
  validates :positive_gain, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :url, :presence => true, uniqueness: true, format: /\Ahttps?:\/\//


end
