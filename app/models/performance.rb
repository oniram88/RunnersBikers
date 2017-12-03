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

require 'pace_type'

class Performance < ApplicationRecord

  belongs_to :user

  attribute :pace, :pace, default: '00:00'

  validates :distance, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 9999.9999 }
  validates :pace, presence: true, format: PaceType.reg_exp
  validates :positive_gain, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :url, :presence => true, uniqueness: true, format: /\Ahttps?:\/\//
  before_save :update_points

  after_save :update_user_points_rank


  # PUNTEGGIO = 100 x ( D + d/100 ) / r
  # Con 	D = distanza in km
  # d = dislivello positivo in m
  # r = ritmo medio in min/km
  def calculate_points
    100 * (distance + positive_gain / 100) / (pace.to_f / 60)
  end


  private
  def update_points
    self.points = calculate_points
  end

  def update_user_points_rank
    self.user.update_points
    self.user.update_rank
  end

end
