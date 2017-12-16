class MatchPolicy < ApplicationPolicy

  def create?
    user == record.challenger and user.open_matches.length == 0
  end

  def approve?
    user.is_judge? and record.approval_waiting?
  end

  def permitted_attributes
    [:id, :note]
  end

  class Scope < Scope
    def resolve
      if user.is_judge? or user.is_admin?
        scope
      else
        scope.none
      end
    end
  end
end
