class RankingController < ApiController

  def index
    @objs = policy_scope(Ranking).order(:rank)
  end

end