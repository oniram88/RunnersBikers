class PerformancesController < ApiController

  before_action :load_user
  before_action :load_obj, only: [:show,:update, :destroy]


  def index
    @objs = policy_scope(Performance).where(user: @user).order(:created_at)
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
    authorize(@obj)
    @operation_result = @obj.update_attributes(clear_params)
    respond_to do |f|
      f.json
    end
  end

  def destroy
    authorize(@obj)
    @operation_result = @obj.destroy
    respond_to do |f|
      f.json
    end
  end

  def show

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
