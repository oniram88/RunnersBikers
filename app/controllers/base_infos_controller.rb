class BaseInfosController < ApiController

  def actual_user
    authorize current_user
  end

end