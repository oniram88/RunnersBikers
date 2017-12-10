class UserPolicy < ApplicationPolicy

  def actual_user?
    user == record
  end


end
