class RankingPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      Ranking.all
    end
  end
end
