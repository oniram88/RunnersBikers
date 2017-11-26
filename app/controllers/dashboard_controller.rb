class DashboardController < RestrictedAreaController

  def main
    authorize :dashboard
  end

end