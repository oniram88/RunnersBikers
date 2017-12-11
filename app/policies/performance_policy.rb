class PerformancePolicy < ApplicationPolicy

  def permitted_attributes

    [
      :distance,
      :pace,
      :positive_gain,
      :url
    ]

  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
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
