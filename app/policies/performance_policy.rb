class PerformancePolicy < ApplicationPolicy

  def permitted_attributes

    [
      :distance,
      :pace,
      :positive_gain,
      :url
    ]

  end


  def show?
    # è una propria oppure è di un match
    super || Match.where(:challenger_p_id => record.id).exists? || Match.where(:challenged_p_id => record.id).exists?
  end

  def update?
    return false if (!record.challenged_match.nil? and
      !record.challenged_match.wait? and
      !record.challenged_match.approval_waiting?) or
      (!record.challenger_match.nil? and
        !record.challenger_match.wait? and
        !record.challenger_match.approval_waiting?)
    user == record.user or user.is_judge?
  end

  def destroy?
    user == record.user and (record.challenged_match.nil? and record.challenger_match.nil?)
  end


  class Scope < Scope
    def resolve
      if user.is_judge? or user.is_admin?
        scope
      else
        scope.merge(user.performances)
      end
    end
  end
end
