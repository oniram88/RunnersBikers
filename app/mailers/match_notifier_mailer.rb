class MatchNotifierMailer < ApplicationMailer


  def notify_creation(match)

    @match = match
    mail(
      to: @match.challenged.email,
      subject: "Sei stato Sfidato da #{@match.challenger}")

  end

  def notify_judge(match,judge)
    @match = match
    mail(to: judge.email, subject: "E' stato sfidato #{@match.challenged} da #{@match.challenger}")
  end


end
