module EmailsHelpers

  def terminate_date(match)
    l match.expiration_date, format: :long
  end


end