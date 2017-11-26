class PerformancePolicy < ApplicationPolicy

  def permitted_attributes

    [
      :distance,
      :pace,
      :positive_gain,
      :url
    ]

  end





  class Scope < Scope
    def resolve
      scope
    end
  end
end
