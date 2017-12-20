class MatchesController < ApiController

  before_action :load_obj, only: [:update, :approve]

  def index
    @objs = policy_scope(Match).order(:created_at => :desc)
  end

  def create
    @obj = current_user.matches_as_challenger.build(params.require(:match).permit(:challenged_id, :points))
    authorize @obj
    @operation_result = @obj.save
    respond_to do |f|
      f.json
    end
  end

  def update
    @operation_result = @obj.update_attributes(clear_params)
    respond_to do |f|
      f.json
    end
  end

  def approve
    @operation_result = @obj.approve(current_user)
    respond_to do |f|
      f.json
    end
  end

  private
  def load_obj
    @obj = Match.find(params[:id])
    authorize @obj
  end

  def clear_params
    params.require(:match).permit(policy(Match.new).permitted_attributes)
  end


end