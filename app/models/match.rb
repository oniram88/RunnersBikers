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

class Match < ApplicationRecord


  belongs_to :challenged, :class_name => "User"
  belongs_to :challenger, :class_name => "User"

  validates :status, :challenged, :challenger, :points, :presence => true

  before_validation :set_defaults

  validate :correct_rank_position

  after_create :email_notify

  enum status: {
    wait: 0,
    finish: 1,
    timeout: 2
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

end
