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

  belongs_to :looser, :class_name => "User", required: false
  belongs_to :winner, :class_name => "User", required: false

  belongs_to :challenged_performance, :class_name => 'Performance',
             foreign_key: 'challenged_p_id', required: false

  belongs_to :challenger_performance, :class_name => 'Performance',
             foreign_key: 'challenger_p_id', required: false

  belongs_to :judge, class_name: 'User', required: false

  validates :status, :challenged, :challenger, :points, :presence => true
  validates :judge, :presence => true, if: -> { approved? or disapproved? }

  validates :looser, :winner, :presence => true, if: -> { approved? or timeout? }

  before_validation :set_defaults

  validate :correct_rank_position

  after_create :email_notify_creation

  after_save :change_status
  after_save :check_status_change


  enum status: {
    wait: 0,
    approved: 1,
    timeout: 2,
    approval_waiting: 3,
    disapproved: 4
  }


  #Data in cui non la sfida scade
  def expiration_date
    self.created_at + RunnersBikers::MATCH_DURATION
  end


  def set_looser_winner

    if challenged_performance.points > challenger_performance.points
      self.winner = challenged
      self.looser = challenger
    else
      self.winner = challenger
      self.looser = challenged
    end

  end
  def set_looser_winner!
    set_looser_winner
    save!
  end


  ##
  # Valida il match
  def approve(judge)
    return false unless judge.is_judge?
    self.judge = judge
    self.status = :approved
    set_looser_winner
    save!
    email_notify_approve_disapprove
  end

  ##
  # Disapprova il match
  def disapprove(judge)
    return false unless judge.is_judge?
    self.judge = judge
    self.status = :disapproved
    save!
    email_notify_approve_disapprove
  end

  private
  def set_defaults
    self.status = :wait if self.status.nil?
  end

  def correct_rank_position

    self.errors.add(:challenged, :to_low_in_rank) if self.challenger.rank - 3 > self.challenged.rank
    self.errors.add(:challenged, :to_high_in_rank) if self.challenger.rank + 3 < self.challenged.rank

  end

  def email_notify_creation
    MatchNotifierMailer.notify_creation(self).deliver
  end

  def email_notify_approve_disapprove
    MatchNotifierMailer.notify_approve_disapprove(self, to: :challenger).deliver
    MatchNotifierMailer.notify_approve_disapprove(self, to: :challenged).deliver
  end

  def notify_judges
    User.with_role(:judge).each do |j|
      MatchNotifierMailer.notify_judge(self.reload, j).deliver
    end
  end

  ##
  # Rispetto alla situazione del match cambia lo status
  def change_status
    if wait? and challenged_performance and challenger_performance
      self.approval_waiting!
      notify_judges
    end
  end

  def check_status_change
    if saved_change_to_status?
      notify_judges
    end
  end

end
