class RankingController < RestrictedAreaController

  def index
    @objs = policy_scope(Ranking)
  end

end