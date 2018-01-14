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
#  winner_id       :integer
#  looser_id       :integer
#  note            :text(65535)
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

  validates :looser, :winner, :presence => true, if: -> { approved? or (timeouted? and !(challenged_performance.nil? and challenger_performance.nil?)) }

  before_validation :set_defaults

  validate :correct_rank_position, on: :create
  validate :max_as_challenged_or_challenger, on: :create
  validate :check_time_limits, on: :create

  after_create :email_notify_creation

  after_save :change_status
  after_save :check_status_change


  enum status: {
    wait: 0,
    approved: 1,
    timeouted: 2,
    approval_waiting: 3,
    disapproved: 4
  }

  scope :open_matches, -> { where(status: [Match.statuses[:wait], Match.statuses[:approval_waiting]]) }


  #Data in cui non la sfida scade
  def expiration_date
    self.created_at + RunnersBikers::MATCH_DURATION
  end


  def set_looser_winner

    if self.approved?
      if challenged_performance.points > challenger_performance.points
        self.winner = challenged
        self.looser = challenger
      else
        self.winner = challenger
        self.looser = challenged
      end
    end
    if self.timeouted?

      if challenged_performance.nil? and !challenger_performance.nil?
        self.winner = challenger
        self.looser = challenged
      end

      if !challenged_performance.nil? and challenger_performance.nil?
        self.winner = challenged
        self.looser = challenger
      end

    end

  end

  def winner_performance
    if winner_id == challenger_id
      challenger_performance
    else
      challenged_performance
    end
  end

  def looser_performance
    if looser_id == challenger_id
      challenger_performance
    else
      challenged_performance
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
    Match.transaction do
      self.judge = judge
      self.status = :approved
      set_looser_winner
      save!
      self.update_rank
    end
    email_notify_approve_disapprove
    true
  end

  ##
  # Disapprova il match
  def disapprove(judge)
    #Per il momento sembra che non ci sia questa situazione
    return false unless judge.is_judge?
    self.judge = judge
    self.status = :disapproved
    save!
    email_notify_approve_disapprove
    true
  end

  ##
  # Controllo se il match è uscito dal tempo massimo
  def outdated?
    expiration_date < Time.now
  end

  ##
  # Check per tutti i match in esecuzione se ci sono alcuni fuori tempo
  def self.check_timeouts
    self.wait.each do |m|
      m.check_timeouts
    end
  end

  ##
  # Metodo chiamato singolarmente sul match
  def check_timeouts
    if self.outdated?
      Match.transaction do
        self.status = :timeouted
        self.set_looser_winner
        self.save!
        self.update_rank
      end
      self.email_notify_outdated
    end
  end

  def update_rank
    if self.looser and self.winner
      self.winner.update_points
      self.looser.update_points
      User.update_rank
    end
  end

  def email_notify_creation
    MatchNotifierMailer.notify_creation(self, to: 'challenger').deliver_later(wait: 1.seconds)
    MatchNotifierMailer.notify_creation(self, to: 'challenged').deliver_later(wait: 1.seconds)
  end

  def email_notify_approval_waiting
    MatchNotifierMailer.notify_approval_waiting(self, to: 'challenger').deliver_later(wait: 1.seconds)
    MatchNotifierMailer.notify_approval_waiting(self, to: 'challenged').deliver_later(wait: 1.seconds)
  end

  def email_notify_approve_disapprove
    MatchNotifierMailer.notify_approve_disapprove(self, to: 'challenger').deliver_later(wait: 1.seconds)
    MatchNotifierMailer.notify_approve_disapprove(self, to: 'challenged').deliver_later(wait: 1.seconds)
  end

  def email_notify_outdated
    MatchNotifierMailer.notify_outdated(self, to: 'challenger').deliver_later(wait: 1.seconds)
    MatchNotifierMailer.notify_outdated(self, to: 'challenged').deliver_later(wait: 1.seconds)
  end

  def notify_judges
    User.with_role(:judge).each do |j|
      MatchNotifierMailer.notify_judge(self.reload, j).deliver_later(wait: 1.seconds)
    end
  end

  private
  def set_defaults
    self.status = :wait if self.status.nil?
  end

  def correct_rank_position

    self.errors.add(:challenged, :to_low_in_rank) if self.challenger.rank - 3 > self.challenged.rank
    self.errors.add(:challenged, :to_high_in_rank) if self.challenger.rank + 3 < self.challenged.rank

  end

  def check_time_limits
    self.errors.add(:created_at, :to_early_for_creation, min_time: RunnersBikers::TIME_TO_START_CHALLENGES) if Time.now < RunnersBikers::TIME_TO_START_CHALLENGES
    self.errors.add(:created_at, :timout_for_creation, max_time: RunnersBikers::MAX_TIME_FOR_START_CHALLENGES) if Time.now > RunnersBikers::MAX_TIME_FOR_START_CHALLENGES
  end

  def max_as_challenged_or_challenger


    if self.challenger.matches_as_challenger.count >= RunnersBikers::MAX_AS_CHALLENGER
      self.errors.add(:challenger, :max_matches_as_challenger, max: RunnersBikers::MAX_AS_CHALLENGER)
    end

    if self.challenged.matches_as_challenged.count >= RunnersBikers::MAX_AS_CHALLENGED
      self.errors.add(:challenged, :max_matches_as_challenged, max: RunnersBikers::MAX_AS_CHALLENGED)
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
