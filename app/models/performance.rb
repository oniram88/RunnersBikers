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
  has_one :challenged_match, class_name: 'Match', foreign_key: :challenged_p_id
  has_one :challenger_match, class_name: 'Match', foreign_key: :challenger_p_id

  attribute :pace, :pace, default: '00:00'

  validates :distance, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 9999.9999 }
  validates :pace, presence: true, format: PaceType.reg_exp
  validates :positive_gain, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :url, :presence => true, uniqueness: true, format: /\Ahttps?:\/\//
  validate :max_insert_time
  before_save :update_points

  after_save :update_user_points_rank
  after_save :check_match_data

  # PUNTEGGIO = 100 x ( D + d/100 ) / r^2
  # Con 	D = distanza in km
  # d = dislivello positivo in m
  # r = ritmo medio in min/km (5:30=> 5+30/60 => 5,5)
  def calculate_points
    (100.0 * (distance.to_f + positive_gain.to_f / 100.0) / (PaceType.to_seconds(pace).to_f / 60.0)**2).to_i
  end

  private

  def update_points
    self.points = calculate_points
  end

  def update_user_points_rank
    self.user.update_points
    User.update_rank
  end

  ##
  # Si occupa di associare questa performance al match se attivo della persona
  def check_match_data
    if user.matches_as_challenger.wait.first
      user.matches_as_challenger.wait.first.update_attributes(challenger_performance: self)
    end
    if user.matches_as_challenged.wait.first
      user.matches_as_challenged.wait.first.update_attributes(challenged_performance: self)
    end
  end

  ##
  # Definizione del tempo massimo di inserimento della performance
  def max_insert_time
    if Time.now >= RunnersBikers::MAX_PERFORMANCE_INSERT
      self.errors.add(:created_at, :challenger_expired, max_time: RunnersBikers::MAX_PERFORMANCE_INSERT)
    end
  end
end
