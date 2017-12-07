class MatchesController < ApiController

  def create
    @obj = current_user.matches_as_challenger.build(params.require(:match).permit(:challenged_id, :points))
    authorize @obj
    @operation_result = @obj.save
    respond_to do |f|
      f.json
    end
  end

end