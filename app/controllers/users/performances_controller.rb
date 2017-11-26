class Users::PerformancesController < PerformancesController


  private
  def load_user
    @user = policy_scope(User).find(params[:user_id])
  end

end
