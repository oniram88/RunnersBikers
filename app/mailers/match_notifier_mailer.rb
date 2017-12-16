class MatchNotifierMailer < ApplicationMailer


  def notify_creation(match)

    @match = match
    mail(
      to: @match.challenged.email,
      subject: "Sei stato Sfidato da #{@match.challenger}")

  end

  def notify_approve_disapprove(match,to: :challenged)

    @match = match
    mail(
      to: @match.send(to).email,
      subject: "Esito Match"
    )

  end

  def notify_outdated(match,to: :challenged)

    @match = match
    mail(
      to: @match.send(to).email,
      subject: "Sfida Scaduta"
    )

  end

  def notify_judge(match,judge)
    @match = match
    mail(to: judge.email, subject: "Sfida #{@match.challenged} VS #{@match.challenger}")
  end


end
