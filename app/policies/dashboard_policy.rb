class DashboardPolicy < ApplicationPolicy


  def main?
    true
  end


  class Scope < Scope
    def resolve
      scope
    end
  end
end
