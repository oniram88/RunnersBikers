class UserPolicy < ApplicationPolicy

  def actual_user?
    user == record
  end

  def show_performances?
    user.is_judge?
  end


  def execute_graph?
    true
  end


  def set_referal_points?
    user.is_judge?
  end
end
