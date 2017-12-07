class MatchPolicy < ApplicationPolicy

  def create?
    user == record.challenger
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
