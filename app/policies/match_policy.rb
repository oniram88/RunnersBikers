class MatchPolicy < ApplicationPolicy

  def create?
    user == record.challenger and user.open_matches.length == 0
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
