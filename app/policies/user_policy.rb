class UserPolicy < ApplicationPolicy

  def actual_user?
    user == record
  end

  def show_performances?
    user.is_judge?
  end


end
