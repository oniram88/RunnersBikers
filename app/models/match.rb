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

class Match < ApplicationRecord


  belongs_to :challenged, :class_name => "User"
  belongs_to :challenger, :class_name => "User"
  belongs_to :challenged_performance, :class_name => 'Performance',
             foreign_key: 'challenged_p_id', required: false

  belongs_to :challenger_performance, :class_name => 'Performance',
             foreign_key: 'challenger_p_id', required: false

  belongs_to :judge, class_name: 'User', required: false

  validates :status, :challenged, :challenger, :points, :presence => true
  validates :judge, :presence => true, if: -> { finish? }

  before_validation :set_defaults

  validate :correct_rank_position

  after_create :email_notify

  after_save :change_status


  enum status: {
    wait: 0,
    finish: 1,
    timeout: 2,
    approval_waiting: 3
  }


  #Data in cui non la sfida scade
  def expiration_date
    self.created_at + RunnersBikers::MATCH_DURATION
  end


  private
  def set_defaults
    self.status = :wait if self.status.nil?
  end

  def correct_rank_position

    self.errors.add(:challenged, :to_low_in_rank) if self.challenger.rank - 3 > self.challenged.rank
    self.errors.add(:challenged, :to_high_in_rank) if self.challenger.rank + 3 < self.challenged.rank

  end

  def email_notify
    MatchNotifierMailer.notify_creation(self).deliver
    User.with_role(:judge).each do |j|
      MatchNotifierMailer.notify_judge(self, j).deliver
    end
  end

  ##
  # Rispetto alla situazione del match cambia lo status
  def change_status
    if wait? and challenged_performance and challenger_performance
      self.update_attributes(status: :approval_waiting)
    end
  end

end
