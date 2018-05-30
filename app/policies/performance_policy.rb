class PerformancePolicy < ApplicationPolicy

  def permitted_attributes

    [
      :distance,
      :pace,
      :positive_gain,
      :url
    ]

  end

  def distance?
    return check_attribute_displayability
  end

  def pace?
    return check_attribute_displayability
  end

  def positive_gain?
    return check_attribute_displayability
  end

  def user_id?
    return check_attribute_displayability
  end

  def user?
    return check_attribute_displayability
  end



  def url?
    return check_attribute_displayability
  end

  def points?
    return check_attribute_displayability
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

  private

  #utilizzato per controllare se i campi sono visibili
  def check_attribute_displayability
    return true unless record.persisted?
    return true if user.is_judge? or user.is_admin?
    #può essere visto se appartiene al match e il match è stato completato
    return true if !record.challenged_match.nil? and (record.challenged_match.approved? or record.challenged_match.timeouted? or record.challenged_match.disapproved?)
    return true if !record.challenger_match.nil? and (record.challenger_match.approved? or record.challenger_match.timeouted? or record.challenger_match.disapproved?)
    return true if is_mine?
  end
end
