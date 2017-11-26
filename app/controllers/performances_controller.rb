class PerformancesController < RestrictedAreaController

  before_action :load_user
  before_action :load_obj, only: [:update, :destroy]


  def index
    policy_scope(Performance).where(user_id: @user_id)
  end

  def create
    @obj = @user.performances.new(clear_params)
    authorize(@obj)
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

  def destroy
    @operation_result = @obj.destroy
    respond_to do |f|
      f.json
    end
  end


  private
  def load_user
    @user = current_user
  end

  def load_obj
    @obj = @user.performances.find(params[:id])
    authorize @obj
  end

  def clear_params
    params.require(:performance).permit(policy(Performance.new).permitted_attributes)
  end

end
