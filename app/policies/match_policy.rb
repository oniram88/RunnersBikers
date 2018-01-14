class MatchPolicy < ApplicationPolicy

  def create?
    user == record.challenger and user.open_matches.length == 0
  end

  def approve?
    user.is_judge? and record.approval_waiting?
  end

  def update_note?
    update?
  end

  def update?
    user.is_judge?
  end

  def permitted_attributes
    [:id, :note]
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
