module EmailsHelpers

  def terminate_date(match)
    l match.expiration_date, format: :long
  end


  def performance_url(p)
    "#{root_url}/#/matches/user/#{p.user_id}/performances/#{p.id}/edit_performance"
  end

end